import 'package:flutter/material.dart';
import 'package:routeen/data/database_helper.dart';
import 'package:routeen/data/task.dart';
import 'edit_tasks_view.dart';

class EditTasks extends StatefulWidget {
  @override
  EditTasksView createState() => EditTasksView();
}

abstract class EditTasksState extends State<EditTasks> {
  TextEditingController controller =
      new TextEditingController(); // for the add task EditText
  List<Task> tasks = new List();
  var db = new DatabaseHelper();

  @override
  initState() {
    super.initState();
    getTasks();
  }

  /// Retrieves the saved tasks in the database
  /// and adds them to the list of tasks
  getTasks() async {
    var fetched = await db.getAllTasks();
    for (int i = 0; i < fetched.length; i++) {
      setState(() {
        tasks.add(Task.fromMap(fetched[i]));
      });
    }
  }

  /// On press of the add task button
  /// Creates a new task given the name from the add task EditText and
  /// Adds the task to the task list
  /// Saves the task to the database
  void addTaskToList() {
    if (controller.text == "") {
      return;
    }
    var name = controller.text;
    setState(() {
      tasks.add(new Task(name, 0)); // 0 for false
      controller.text = ""; // reset TextEdit text
    });
    addTaskToDB(name, false);
  }

  /// saves a task to the database
  void addTaskToDB(String name, bool isCompleted) async {
    await db.insert(new Task(name, isCompleted ? 1 : 0));
  }

  /// called if an item is swiped left or right
  /// remove task from task list and from database
  /// show snackbar giving acknowledgement that the task has been deleted
  void removeTask(BuildContext context, int index) async {
    String taskName = tasks[index].name;
    setState(() {
      tasks.removeAt(index);
    });
    await db.deleteTask(taskName);

    Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text("Deleted $taskName"),
          ),
        );
  }
}
