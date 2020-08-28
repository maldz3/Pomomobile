import 'package:flutter/material.dart';
import 'package:pomodoro_timer/models/task.dart';
import 'package:pomodoro_timer/widgets/custom_drawer.dart';
import 'package:pomodoro_timer/widgets/one_task.dart';


class SingleTask extends StatelessWidget{
  final Task task;
  SingleTask({Key key, @required this.task}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Center(child: Text('Task Details')),
            actions: <Widget>[
              Builder(builder: (context) =>
                  IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () => Scaffold.of(context).openEndDrawer()))]),
        endDrawer: CustomDrawer(),
        body: Center(child: OneTask(task: task))
    );
  }
}