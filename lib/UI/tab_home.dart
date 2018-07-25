import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:routeen/UI/Login/login_state.dart';
import 'package:routeen/UI/Tabs/friends_state.dart';
import 'package:routeen/UI/Tabs/profile_state.dart';
import 'Tabs/home_state.dart';
import 'Tabs/edit_tasks_state.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class TabBarHome extends StatefulWidget {
  @override
  _TabBarHomeState createState() => _TabBarHomeState();
}

class _TabBarHomeState extends State<TabBarHome> {
  int _navIndex = 0;

  List<Widget> screens = [Home(), EditTasks(), Friends(), Profile()];

  logOut() {
    _auth.signOut();
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      Login();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Routeen"),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: logOut,
          ),
        ],
      ),
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
              "Tasks",
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
