import 'package:flutter/material.dart';
import 'package:pomodoro_timer/db/database_manager.dart';
import 'package:pomodoro_timer/models/task.dart';
import 'package:pomodoro_timer/widgets/tasks_contents.dart';
import 'package:pomodoro_timer/widgets/tasks_scaffold.dart';
import 'package:pomodoro_timer/widgets/welcome.dart';


class TaskListScreen extends StatefulWidget {
  static const routeName = 'tasks';

  @override
  TaskListScreenState createState() => TaskListScreenState();
}

class TaskListScreenState extends State<TaskListScreen> {
  TaskList taskList;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() async {
    final databaseManager = DatabaseManager.getInstance();
    List<Task> tasks = await databaseManager.getTasks();
    setState(() {
      taskList = TaskList(tasks: tasks);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (taskList == null) {
      return TaskScaffold(
          appBarTitle: 'Loading Tasks',
          body: Center(child: CircularProgressIndicator())
      );
    } else {
      return TaskScaffold(
          appBarTitle: taskList.isEmpty ? 'Pomodoro Timer' : 'Tasks',
          body: taskList.isEmpty ? WelcomeScreen() : TaskContents(taskList: taskList)
      );
    }
  }
}