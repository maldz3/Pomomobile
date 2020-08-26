import 'dart:async';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pomodoro_timer/db/database_manager.dart';
import 'package:pomodoro_timer/models/task.dart';
import 'package:pomodoro_timer/widgets/auto_size_text.dart';

class TimerScreen extends StatefulWidget {
  final Task task;

  TimerScreen({this.task});

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

//Code based on: https://www.youtube.com/watch?v=tRe8teyf9Nk&feature=youtu.be
class _TimerScreenState extends State<TimerScreen> with TickerProviderStateMixin {
  Task task;
  bool breakTime;
  String taskType;

  int accumulatedSeconds;
  Timer _everySecondTimer;
  int segmentTime;
  bool blinker = true;
  AnimationController _controller;
  Icon playPauseIcon = Icon(Icons.play_arrow);
  final player = AudioCache();

  @override
  void initState() {
    super.initState();
    task = this.widget.task;

    breakTime = true; // transition will toggle, so this will start with work.
    transition();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
  }

  @override
  void dispose() {
    if (_everySecondTimer != null) _everySecondTimer.cancel();
    _controller.dispose();
    super.dispose();
  }

  String get timerString {
    int delta = segmentTime - accumulatedSeconds;
    String minutes = (delta ~/ 60).toString();
    String seconds = (delta % 60).toString();
    if (seconds.length == 1) seconds = '0' + seconds;
    return minutes + ":" + seconds;
  }

  void start() {
    setState(() {
      playPauseIcon = Icon(Icons.pause);
    });

    _everySecondTimer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      accumulatedSeconds++;

      int delta = segmentTime - accumulatedSeconds;
      if (delta <= 0) {
        transition();
      }
      if (delta == 30) {
        var alert = showAlert(context);
        player.play("chime.mp3");
      }

      setState(() {});
    });
  }

  void pause() {
    if (_everySecondTimer != null) _everySecondTimer.cancel();
    setState(() {
      playPauseIcon = Icon(Icons.play_arrow);
    });
  }

  void transition() {
    updateTotalTime();
    breakTime = !breakTime;
    if (breakTime == false) {
      taskType = 'Work';
      segmentTime = task.workTime * 60;
    } else {
      taskType = 'Break';
      segmentTime = task.breakTime * 60;
    }

    accumulatedSeconds = 0;
  }

  Future<Widget> showAlert(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 2), () {
            Navigator.of(context).pop();
          });
          return AlertDialog(
            title: Center(child: Text('30 seconds remaining')),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                updateTotalTime();
                if (_everySecondTimer != null) _everySecondTimer.cancel();
                Navigator.of(context).pop();
              },
              child: Icon(Icons.arrow_back)),
          centerTitle: true,
          title: Text(task.name)),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(children: <Widget>[
          timer(context),
          SizedBox(height: 10),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                playPauseButton(context),
                stopButton(context),
              ]),
          SizedBox(height: 10),
          skipButton(context),
        ]),
      ),
    );
  }

  Widget timer(BuildContext context) {
    final timerChildren = List<Widget>();

    //// add circular progress indicator
    // this part adds color transition
    Animation<Color> _colorAnimation = ColorTween(
      begin: Colors.greenAccent,
      end: Colors.lightBlueAccent,
    ).animate(_controller);
    // calculate current progress
    double progress =
        (segmentTime - accumulatedSeconds).toDouble() / segmentTime.toDouble();
    _controller.value = progress;
    // add circle to children
    timerChildren.add(Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: CircularProgressIndicator(
            valueColor: _colorAnimation,
            value: progress,
            strokeWidth: 10,
          ),
        )
      ],
    ));

    timerChildren.add(Align(
      alignment: FractionalOffset.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          AutoSizeText(
            breakTime ? 'Break Time' : "Work!",
            style: TextStyle(fontSize: 25),
            maxLines: 1,
          ),
          AutoSizeText(
            timerString,
            style: TextStyle(fontSize: 50),
            maxLines: 1,
          ),
        ],
      ),
    ));

    return Expanded(
      child: Align(
        alignment: FractionalOffset.center,
        child: AspectRatio(
          aspectRatio: 1.0,
          child: Stack(
            children: timerChildren,
          ),
        ),
      ),
    );
  }

  Widget playPauseButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.greenAccent,
      child: playPauseIcon,
      onPressed: () {
        if (_everySecondTimer != null && _everySecondTimer.isActive) {
          pause();
        } else {
          start();
        }
      },
    );
  }

  Widget stopButton(BuildContext context) {
    return RaisedButton(
        child: Icon(Icons.stop),
        color: Colors.red,
        onPressed: () {
          updateTotalTime();
          if (_everySecondTimer != null) _everySecondTimer.cancel();
          Navigator.of(context).pop();
        });
  }

  Widget skipButton(BuildContext context) {
    return RaisedButton(
        child: Text('Skip to next'),
        onPressed: () {
          setState(() {
            transition();
          });
        });
  }

  void updateTotalTime() {
    if (breakTime == true) {
      return;
    } else {
      int accomplished = (accumulatedSeconds / 60.0).round();
        task.addTime(accomplished);
        final databaseManager = DatabaseManager.getInstance();
        databaseManager.updateTime(updateTask: task);
      }
    }
  }