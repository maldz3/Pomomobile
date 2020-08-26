import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pomodoro_timer/widgets/picture.dart';

class WelcomeScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Center(child: Padding( padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text('Welcome to your Pomodoro Timer!', 
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.pink[800]), 
                textAlign: TextAlign.center),
            SizedBox(height: 90),
            Text('Please add a task...', 
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.teal)),
            SizedBox(height: 30),
            Picture()
          ],
        )),
    );
  }
}
