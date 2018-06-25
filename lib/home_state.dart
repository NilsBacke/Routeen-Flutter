import 'package:flutter/material.dart';
import 'home_view.dart';

class Home extends StatefulWidget {
  @override
  HomePageView createState() => new HomePageView();
}

abstract class HomeState extends State<Home> {
  int streak = 0;
  String keepItUp = "Keep It Up!";
  List<bool> isCompletedValues = new List.filled(3, false);

  void alterTask(bool checkboxVal, int index) {
    setState(() {
      isCompletedValues[index] = checkboxVal;
    });
  }
}
