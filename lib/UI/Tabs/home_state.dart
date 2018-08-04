import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'edit_tasks_state.dart';
import 'home_view.dart';

const keepItUp = "Keep It Up!";
const startAnother = "Start up a streak!";

final Firestore db = Firestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class Home extends StatefulWidget {
  @override
  HomeView createState() => new HomeView();
}

abstract class HomeState extends State<Home> {
  int streak = 0; // current day streak
  int dayLastCompleted;
  String motivationText = keepItUp; // text that changes depending on streak
  String userUID = '';

  @override
  initState() {
    super.initState();
    setUserUID();
    dayLastCompleted = getToday() - 1;
    loadStreak();
  }

  void loadStreak() async {
    await getStreak();

    if (streak == 0) {
      motivationText = startAnother;
    } else {
      motivationText = keepItUp;
    }
  }

  /// Change a task's isCompleted value
  /// and update the task in the database
  void alterTask(bool checkboxVal, DocumentSnapshot docSnap) async {
    docSnap.reference.updateData({'isCompleted': checkboxVal});

    await updateStreak(); // check if streak should be incremented
  }

  /// update streak if applicable
  Future updateStreak() async {
    // increment streak
    bool allComplete = await allCompleted();
    if (allComplete &&
        (getToday() - dayLastCompleted == 1 ||
            streak == 0 && dayLastCompleted != getToday())) {
      incrementStreak();
      saveStreak();
      dayLastCompleted = getToday();
      incrementStreakDialog();
    }
  }

  /// check if all of the tasks in the list are completed
  Future<bool> allCompleted() async {
    var doc = await getUserDoc();
    var docs = await doc.collection('tasks').getDocuments();
    for (DocumentSnapshot task in docs.documents) {
      if (!task.data['isCompleted']) {
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

  /// save the streak number using firestore
  Future saveStreak() async {
    getUserDoc().then((val) {
      val.updateData({'streak': streak, 'dayLastCompleted': dayLastCompleted});
    });
  }

  /// retrieve the streak number from firestore
  Future getStreak() async {
    getUserSnapshot().then((val) async {
      if (val.data['streak'] == null) {
        // check if nothing saved so far
        await saveStreak();
      }
      streak = val.data['streak'];
      dayLastCompleted = val.data['dayLastCompleted'];
    });

    checkForLossOfStreak();
  }

  /// go to the compose page and update the tasks list upon pop back to the home page
  void composePage(BuildContext context) async {
    Navigator
        .of(context)
        .push(MaterialPageRoute(builder: (context) => EditTasks()));
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

  Future<String> getUserUID() async {
    var useruid;
    if (userUID == '') {
      useruid = await getUserUIDFromAuth();
    } else {
      useruid = userUID;
    }
    return useruid;
  }

  Future<String> getUserUIDFromAuth() async {
    var user = await _auth.currentUser();
    return user.uid;
  }

  Future<DocumentReference> getUserDoc() async {
    var useruid = await getUserUID();
    return db.collection('users').document(useruid);
  }

  Future<DocumentSnapshot> getUserSnapshot() async {
    var doc = await getUserDoc();
    return await doc.get();
  }

  void setUserUID() async {
    var _userUID = await getUserUID();
    setState(() {
      userUID = _userUID;
    });
  }
}
