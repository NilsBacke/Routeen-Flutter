import 'package:flutter/material.dart';
import 'package:routeen/UI/Tabs/profile_state.dart';

class ProfileView extends ProfileState {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.person_outline,
                color: Colors.black54,
                size: 100.0,
              ),
              Text(
                "name",
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.w100,
                ),
              ),
              Text(
                "email",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w200,
                ),
              ),
              followingRow(),
              Text(
                "Current Streak:",
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.w100,
                ),
              ),
              Text(
                "1",
                style: TextStyle(
                  color: Color(0xFF1dcaff),
                  fontSize: 120.0,
                  fontWeight: FontWeight.w100,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget followingRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Following",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w100,
              ),
            ),
            Text(
              "32",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        RotatedBox(
          quarterTurns: 1,
          child: Divider(
            height: 150.0,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Followers",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w100,
              ),
            ),
            Text(
              "32",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
