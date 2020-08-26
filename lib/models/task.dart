class TaskList {
  List<Task> tasks;

  TaskList({this.tasks});

  bool get isEmpty {
    if (tasks.isEmpty) {
      return true;
    }
    return false;
  }
}

class Task {
  int id;
  String name;
  String description;
  int workTime;
  int breakTime;
  int goal;
  int totalTime;

  Task(
      {this.id,
      this.name,
      this.description,
      this.workTime,
      this.breakTime,
      this.goal,
      this.totalTime});

  void addTime(int time) {
    totalTime += time;
  }
}