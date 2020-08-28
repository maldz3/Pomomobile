import 'package:flutter/material.dart';
import 'package:pomodoro_timer/widgets/picture.dart';
import 'package:pomodoro_timer/widgets/custom_drawer.dart';
import 'package:pomodoro_timer/screens/task_list.dart';


class HomePage extends StatelessWidget {
  static const routeName = 'home';

  final appBarTitle = 'Pomodoro Timer';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Center(child: Text(appBarTitle)),
            actions: <Widget>[
              Builder(builder: (context) =>
                  IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () => Scaffold.of(context).openEndDrawer()
                    ))]),
        endDrawer: CustomDrawer(),
        body: Body(context)
    );
  }
    
  Widget Body(BuildContext context) { 
    return Center(child: Padding(padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text('Welcome to your Pomodoro Timer!', 
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.teal), 
                textAlign: TextAlign.center),
            SizedBox(height: 90),
            GestureDetector(
              child: Picture(),
              onTap: () async {
                await Navigator.pushNamed(context, 'tasks');
              }
            )
          ],
        )),
    );
  }
}
