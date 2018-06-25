import 'package:flutter/material.dart';
import 'edit_tasks_view.dart';

class EditTasks extends StatefulWidget {
  @override
  EditTasksView createState() => EditTasksView();
}

abstract class EditTasksState extends State<EditTasks> {
  TextEditingController controller = new TextEditingController();
  List<String> tasks = new List();

  void addTaskToList() {
    setState(() {
      tasks.add(controller.text);
      controller.text = "";
    });
  }
}
