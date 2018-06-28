import 'dart:async';

import 'package:flutter/material.dart';
import 'home_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  HomePageView createState() => new HomePageView();
}

abstract class HomeState extends State<Home> {
  int streak = 0;
  String keepItUp = "Keep It Up!";
  List<bool> isCompletedValues = new List.filled(3, false);

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  initState() {
    super.initState();
    getStreak();
  }

  void alterTask(bool checkboxVal, int index) {
    setState(() {
      isCompletedValues[index] = checkboxVal;
    });
    updateStreak();
  }

  bool allCompleted() {
    for (bool val in isCompletedValues) {
      if (!val) {
        return false;
      }
    }
    return true;
  }

  void updateStreak() {
    if (allCompleted() /* and they weren't last completed today */) {
      incrementStreak();
      saveStreak();
    }
  }

  void incrementStreak() {
    setState(() {
      streak++;
    });
  }

  saveStreak() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setInt('streak', streak);
  }

  getStreak() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      streak = (prefs.getInt('streak') ?? 0);
    });
  }
}
