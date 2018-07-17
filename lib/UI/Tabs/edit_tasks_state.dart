import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'edit_tasks_view.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final Firestore db = Firestore.instance;

class EditTasks extends StatefulWidget {
  @override
  EditTasksView createState() => EditTasksView();
}

abstract class EditTasksState extends State<EditTasks> {
  TextEditingController controller =
      new TextEditingController(); // for the add task EditText
  String userUID = '';

  @override
  initState() {
    super.initState();
    setUserUID();
    // getTasks();
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
      controller.text = ""; // reset TextEdit text
    });
    addTaskToDB(name, false);
  }

  /// saves a task to the database
  void addTaskToDB(String name, bool isCompleted) async {
    // await db.insert(new Task(name, isCompleted ? 1 : 0));
    getTasksCollection().then((val) {
      val.add({'name': name, 'isCompleted': isCompleted});
    });
  }

  /// called if an item is swiped left or right
  /// remove task from task list and from database
  /// show snackbar giving acknowledgement that the task has been deleted
  void removeTask(BuildContext context, String docId) async {
    getTasksCollection().then((val) {
      val.document(docId).delete();
    });
    Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text("Deleted task successfully"),
          ),
        );
  }

  Future<FirebaseUser> getUser() async {
    return await _auth.currentUser();
  }

  Future<String> getUserUID() async {
    var user = await _auth.currentUser();
    return user.uid;
  }

  Future<CollectionReference> getTasksCollection() async {
    var useruid = await getUserUID();
    return db.collection('users').document(useruid).collection('tasks');
  }

  void setUserUID() async {
    var _userUID = await getUserUID();
    setState(() {
      userUID = _userUID;
    });
  }
}
