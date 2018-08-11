import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:routeen/UI/Login/login_state.dart';
import 'package:routeen/UI/Tabs/following_state.dart';
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

  List<Widget> screens = [Home(), EditTasks(), Following(), Profile()];

  void logOut() {
    _auth.signOut().then((val) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
        return Login();
      }));
    });
  }

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
                  Colors.lightBlueAccent[400],
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
            actions: <Widget>[
              _navIndex == 3
                  ? IconButton(
                      icon: Icon(Icons.exit_to_app),
                      onPressed: logOut,
                    )
                  : Container(),
            ],
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
              // color: Colors.lightBlueAccent,
            ),
            title: Text(
              "Home",
              // style: TextStyle(color: Colors.lightBlueAccent),
            ),
            // backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.edit,
              // color: Colors.lightBlueAccent,
            ),
            title: Text(
              "Tasks",
              // style: TextStyle(color: Colors.lightBlueAccent),
            ),
            // backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.people,
              // color: Colors.lightBlueAccent,
            ),
            title: Text(
              "Following",
              // style: TextStyle(color: Colors.lightBlueAccent),
            ),
            // backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              // color: Colors.lightBlueAccent,
            ),
            title: Text(
              "Profile",
              // style: TextStyle(color: Colors.lightBlueAccent),
            ),
            // backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
