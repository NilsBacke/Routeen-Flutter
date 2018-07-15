import 'package:flutter/material.dart';
import 'Tabs/home_state.dart';
import 'Tabs/edit_tasks_state.dart';

class TabBarHome extends StatefulWidget {
  @override
  _TabBarHomeState createState() => _TabBarHomeState();
}

class _TabBarHomeState extends State<TabBarHome> {
  int _navIndex = 0;

  List<Widget> screens = [Home(), EditTasks(), Home(), EditTasks()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_navIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.lightBlueAccent,
        currentIndex: _navIndex,
        onTap: (int i) {
          setState(() {
            _navIndex = i;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            title: Text(
              "Home",
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.edit,
            ),
            title: Text(
              "Edit Tasks",
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.people,
            ),
            title: Text(
              "Friends",
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
            ),
            title: Text(
              "Profile",
            ),
          ),
        ],
      ),
    );
  }
}
