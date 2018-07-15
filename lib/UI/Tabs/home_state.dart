import 'dart:async';
import 'package:flutter/material.dart';
import 'edit_tasks_state.dart';
import 'package:routeen/data/database_helper.dart';
import 'package:routeen/data/task.dart';
import 'home_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

final String keepItUp = "Keep It Up!";
final String startAnother = "Start up a streak!";

class Home extends StatefulWidget {
  @override
  HomeView createState() => new HomeView();
}

abstract class HomeState extends State<Home> {
  int streak = 0; // current day streak
  int dayLastCompleted;
  String motivationText; // text that changes depending on streak
  List<Task> tasks = <Task>[];

  Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance(); // to store streak
  var db = new DatabaseHelper();

  @override
  initState() {
    super.initState();
    dayLastCompleted = getToday() - 1;
    getStreak();
    getTasks();

    if (streak == 0) {
      motivationText = startAnother;
    } else {
      motivationText = keepItUp;
    }
  }

  @override
  void dispose() {
    super.dispose();
    saveTasks();
  }

  /// Retrieves the saved tasks in the database
  /// and adds them to the list of tasks
  void getTasks() async {
    var fetched = await db.getAllTasks();
    bool needToResetChecks = getToday() != dayLastCompleted;
    for (int i = 0; i < fetched.length; i++) {
      setState(() {
        tasks.add(Task.fromMap(fetched[i]));
      });
      if (needToResetChecks) {
        alterTask(false, i);
      }
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

  void saveTasks() async {
    tasks.forEach((task) async {
      await db.updateTask(new Task(task.name, task.isCompleted));
    });
  }

  /// update streak if applicable
  void updateStreak() {
    // increment streak
    if (allCompleted() && getToday() - dayLastCompleted == 1) {
      incrementStreak();
      saveStreak();
      dayLastCompleted = getToday();
      incrementStreakDialog();
    }
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

  /// increment the streak by one
  void incrementStreak() {
    setState(() {
      streak++;
      motivationText = keepItUp;
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
      dayLastCompleted = (prefs.getInt('dayLastCompleted') ?? getToday() - 1);
    });
    checkForLossOfStreak();
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

  /// checks if the user's streak is lost
  /// streak is lost if there was a more than one day gap
  /// then performs appropriate actions
  void checkForLossOfStreak() {
    if (getToday() - dayLastCompleted > 1) {
      // loss of streak
      lossOfStreakDialog();
      resetStreak();
      saveStreak();
    }
  }

  /// displays the dialog if the user's streak is lost
  void lossOfStreakDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                "img/frown.png",
                width: 100.0,
                height: 100.0,
              ),
              new Text(
                "Sorry, you lost your streak",
                textAlign: TextAlign.center,
                style: new TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
          content: new Text(
            startAnother,
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  /// displays the dialog if the user's streak is continued
  void incrementStreakDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                "img/happy.png",
                width: 100.0,
                height: 100.0,
              ),
              new Text(
                "Well Done!",
                textAlign: TextAlign.center,
                style: new TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
          content: new Text(
            "Come back tomorrow to continue your streak.",
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  /// resets the current streak
  /// only called if the user's current streak is lost
  void resetStreak() {
    setState(() {
      streak = 0;
      motivationText = startAnother;
    });
    dayLastCompleted = getToday();
  }
}
