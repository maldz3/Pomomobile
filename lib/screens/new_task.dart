import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pomodoro_timer/db/database_manager.dart';
import 'package:pomodoro_timer/screens/task_list.dart';
import 'package:pomodoro_timer/widgets/custom_drawer.dart';
import 'package:pomodoro_timer/db/task_dto.dart';

//New Journal Entry form
class NewTaskForm extends StatefulWidget {
  static const routeName = 'newTask';

  _NewTaskFormState createState() => _NewTaskFormState();
}

class _NewTaskFormState extends State<NewTaskForm> {
  final formKey= GlobalKey<FormState>();
  final newTask = TaskDTO();

  @override
  void initState() {
    super.initState();
    newTask.totalTime = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Center(child: Text('New Task Entry')),
            actions: <Widget>[
              Builder(builder: (context) =>
                  IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () => Scaffold.of(context).openEndDrawer()))]),
        endDrawer: CustomDrawer(),
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
                key: formKey,
                child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                                initialValue: newTask.name,
                                autofocus: false,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) =>
                                    FocusScope.of(context).nextFocus(),
                                decoration: InputDecoration(
                                    labelText: 'Task Name',
                                    border: OutlineInputBorder()),
                                onSaved: (value) {
                                  newTask.name = value;
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter a task name';
                                  } else {
                                    return null;
                                  }
                                }
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                                initialValue: newTask.description,
                                autofocus: false,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) =>
                                    FocusScope.of(context).nextFocus(),
                                decoration: InputDecoration(
                                    labelText: 'Description',
                                    border: OutlineInputBorder()),
                                onSaved: (value) {
                                  newTask.description = value;
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter a description';
                                  } else {
                                    return null;
                                  }
                                }
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                                initialValue: (newTask.workTime == null)
                                    ? null
                                    : newTask.workTime.toString(),
                                keyboardType: TextInputType.number,
                                autofocus: false,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) =>
                                    FocusScope.of(context).nextFocus(),
                                inputFormatters: <TextInputFormatter>[
                                  WhitelistingTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                    labelText: 'Task Duration (Minutes)',
                                    border: OutlineInputBorder()),
                                onSaved: (value) {
                                  newTask.workTime = int.tryParse(value);
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter a task duration';
                                  } else {
                                    return null;
                                  }
                                }
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                                initialValue: (newTask.breakTime == null)
                                    ? null
                                    : newTask.breakTime.toString(),
                                keyboardType: TextInputType.number,
                                autofocus: false,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) =>
                                    FocusScope.of(context).nextFocus(),
                                inputFormatters: <TextInputFormatter>[
                                  WhitelistingTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                    labelText: 'Break Duration (Minutes)',
                                    border: OutlineInputBorder()),
                                onSaved: (value) {
                                  newTask.breakTime = int.tryParse(value);
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter a break duration';
                                  } else {
                                    return null;
                                  }
                                }
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                                initialValue: (newTask.goal == null)
                                    ? null
                                    : newTask.goal.toString(),
                                keyboardType: TextInputType.number,
                                autofocus: false,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) =>
                                    FocusScope.of(context).nextFocus(),
                                inputFormatters: <TextInputFormatter>[
                                  WhitelistingTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                    labelText: 'Goal Time (Minutes)',
                                    border: OutlineInputBorder()),
                                onSaved: (value) {
                                  newTask.goal = int.tryParse(value);
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter a goal time';
                                  } else {
                                    return null;
                                  }
                                }
                            ),
                            SizedBox(height: 8),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  RaisedButton(
                                      color: Colors.red,
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancel')
                                  ),
                                  RaisedButton(
                                      onPressed: () async {
                                        if (formKey.currentState.validate()) {
                                          formKey.currentState.save();
                                          final databaseManager = DatabaseManager.getInstance();
                                          databaseManager.saveTask(newTask: newTask);
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => TaskListScreen()));
                                        }
                                      },
                                      child: Text('Save Entry')
                                  )
                                ]
                            )
                          ]
                      ),
                    )
                )
            )
        )
    );
  }
}