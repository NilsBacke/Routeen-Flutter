import 'package:flutter/material.dart';
import 'package:routeen/UI/Tabs/friends_state.dart';
import 'package:routeen/UI/Tabs/profile_state.dart';
import 'Tabs/home_state.dart';
import 'Tabs/edit_tasks_state.dart';

class TabBarHome extends StatefulWidget {
  @override
  _TabBarHomeState createState() => _TabBarHomeState();
}

class _TabBarHomeState extends State<TabBarHome> {
  int _navIndex = 0;

  List<Widget> screens = [Home(), EditTasks(), Friends(), Profile()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [
                  0.1,
                  0.9,
                ],
                colors: [
                  Colors.lightBlueAccent,
                  Colors.grey[50],
                ],
              ),
            ),
          ),
          AppBar(
            title: Text(
              "Routeen",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w300,
                fontSize: 28.0,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          screens[_navIndex],
        ],
      ),
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
              "Tasks",
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.people,
            ),
            title: Text(
              "Following",
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
