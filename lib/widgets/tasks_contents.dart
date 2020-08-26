import 'package:flutter/material.dart';
import 'package:pomodoro_timer/db/database_manager.dart';
import 'package:pomodoro_timer/models/task.dart';
import 'package:pomodoro_timer/screens/single_task.dart';
import 'package:pomodoro_timer/screens/task_list.dart';
import 'package:pomodoro_timer/widgets/one_task.dart';
import 'package:pomodoro_timer/screens/timer_page.dart';

class TaskContents extends StatefulWidget {
  final TaskList taskList;

  TaskContents({Key key, @required this.taskList}) : super(key: key);

  @override
  _TaskContentsState createState() => _TaskContentsState();
}

class _TaskContentsState extends State<TaskContents> {
  Task _selectedTask;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (layoutDecider));
  }

  Widget layoutDecider(BuildContext context, BoxConstraints constraints) {
    return constraints.maxWidth < 500 ? verticalLayout() : horizontalLayout();
  }

  Widget verticalLayout() {
    return Container(
        child: ListView.builder(
      itemCount: this.widget.taskList.tasks.length,
      itemBuilder: (context, index) {
        return Dismissible(
          onDismissed: (DismissDirection direction) {
            setState(() {
              final db = DatabaseManager.getInstance();
              db.deleteTask(deleteTask: this.widget.taskList.tasks[index]);
              this.widget.taskList.tasks.removeAt(index);
              if (this.widget.taskList.tasks.length == 0) {
                Navigator.popAndPushNamed(context, TaskListScreen.routeName);
              }
            });
          },
          secondaryBackground: Container(
            child: Center(
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
            ),
            color: Colors.red,
          ),
          background: Container(),
          child: ListTile(
              onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SingleTask(
                                task: this.widget.taskList.tasks[index])))
                  },
              leading: playButton(index),
              title: Text('${this.widget.taskList.tasks[index].name}'),
              subtitle: Text(
                  'Total time: ${this.widget.taskList.tasks[index].totalTime}')),
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
        );
      },
    ));
  }

  Widget horizontalLayout() {
    if (_selectedTask == null) {
      _selectedTask = this.widget.taskList.tasks[0];
    }

    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Expanded(
          child: Container(
              child: ListView.builder(
        itemCount: this.widget.taskList.tasks.length,
        itemBuilder: (context, index) {
          return Dismissible(
            onDismissed: (DismissDirection direction) {
              setState(() {
                final db = DatabaseManager.getInstance();
                db.deleteTask(deleteTask: this.widget.taskList.tasks[index]);
                this.widget.taskList.tasks.removeAt(index);
                if (this.widget.taskList.tasks.length == 0) {
                  Navigator.popAndPushNamed(context, TaskListScreen.routeName);
                } else {
                  _selectedTask = this.widget.taskList.tasks[0];
                }
              });
            },
            secondaryBackground: Container(
              child: Center(
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              color: Colors.red,
            ),
            background: Container(),
            child: ListTile(
                onTap: () => setState(() {
                      _selectedTask = this.widget.taskList.tasks[index];
                    }),
                leading: playButton(index),
                title: Text('${this.widget.taskList.tasks[index].name}'),
                subtitle: Text(
                    'Total time: ${this.widget.taskList.tasks[index].totalTime}')),
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
          );
        },
      ))),
      Expanded(child: Container(child: OneTask(task: _selectedTask)))
    ]);
  }

  Widget playButton(int index) {
    return FlatButton(
        child: Icon(Icons.play_arrow),
        color: Colors.greenAccent,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TimerScreen(
                    task: this.widget.taskList.tasks[index])),
          );
          setState(() => {});
        });
  }
}