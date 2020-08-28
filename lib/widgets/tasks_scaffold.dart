import 'package:flutter/material.dart';
import 'package:pomodoro_timer/screens/home_page.dart';
import 'custom_drawer.dart';
import 'package:pomodoro_timer/screens/new_task.dart';


class TaskScaffold extends StatelessWidget {
  final String appBarTitle;
  final Widget body;

  TaskScaffold({this.appBarTitle, this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: GestureDetector(
              onTap: () { Navigator.popAndPushNamed(context, HomePage.routeName); },
              child: Icon(
                Icons.home,  // add custom icons also
              ),
            ),
            title: Center(child: Text(appBarTitle)),
            actions: <Widget>[
              Builder(builder: (context) =>
                  IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () => Scaffold.of(context).openEndDrawer()))]),
        endDrawer: CustomDrawer(),
        body: body,
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () { Navigator.pushNamed(context, NewTaskForm.routeName);}
        ));
  }
}