import 'dart:async';
import 'package:flutter/material.dart';
import 'package:routeen/UI/edit_tasks_state.dart';
import 'package:routeen/data/database_helper.dart';
import 'package:routeen/data/task.dart';
import 'home_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  HomeView createState() => new HomeView();
}

abstract class HomeState extends State<Home> {
  int streak = 0; // current day streak
  int dayLastCompleted = 0;
  String keepItUp = "Keep It Up!"; // text that changes depending on streak
  List<Task> tasks = <Task>[];

  Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance(); // to store streak
  var db = new DatabaseHelper();

  @override
  initState() {
    super.initState();
    getStreak();
    getTasks();
    print("${getToday()}");
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

  /// Change a task's isCompleted value
  /// and update the task in the database
  void alterTask(bool checkboxVal, int index) async {
    int isNowCompleted = checkboxVal ? 1 : 0;
    setState(() {
      tasks[index].isCompleted = isNowCompleted;
    });

    await db.updateTask(new Task(tasks[index].name, isNowCompleted));

    updateStreak(); // check if streak should be incremented
  }

  /// check if all of the tasks in the list are completed
  bool allCompleted() {
    for (Task task in tasks) {
      if (task.isCompleted == 0) {
        return false;
      }
    }
    return true;
  }

  /// update streak if applicable
  void updateStreak() {
    if (allCompleted() && dayLastCompleted != getToday()) {
      incrementStreak();
      saveStreak();
      dayLastCompleted = getToday();
    }
  }

  /// increment the streak by one
  void incrementStreak() {
    setState(() {
      streak++;
    });
  }

  /// save the streak number using shared preferences
  void saveStreak() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setInt('streak', streak);
    prefs.setInt('dayLastCompleted', dayLastCompleted);
  }

  /// retrieve the streak number from shared preferences
  void getStreak() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      streak = (prefs.getInt('streak') ?? 0);
      dayLastCompleted = (prefs.getInt('dayLastCompleted') ?? 0);
    });
  }

  /// go to the compose page and update the tasks list upon pop back to the home page
  void composePage(BuildContext context) async {
    final newTasks = await Navigator
        .of(context)
        .push(MaterialPageRoute(builder: (context) => EditTasks()));

    setState(() {
      tasks = newTasks;
    });
  }

  /// returns an int that represents the day of the month
  int getToday() {
    DateTime today = DateTime.now();
    return today.day; // an integer
  }
}
