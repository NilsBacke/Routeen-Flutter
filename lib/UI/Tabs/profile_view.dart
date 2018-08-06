import 'package:flutter/material.dart';
import 'package:routeen/UI/Tabs/profile_state.dart';
import 'package:routeen/data/data.dart';

const profPicPadding = 16.0;
const namePadding = 12.0;
const emailPadding = 12.0;
const followagePadding = 16.0;
const currStreakPadding = 8.0;
const streakPadding = 16.0;

class ProfileView extends ProfileState {
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Padding(
      padding: EdgeInsets.only(top: getTopPadding(context)),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: logOut,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(profPicPadding),
                child: Icon(
                  Icons.person_outline,
                  color: Colors.white70,
                  size: 100.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(namePadding),
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w100,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(emailPadding),
                child: Text(
                  email,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w200,
                    color: Colors.white,
                  ),
                ),
              ),
              followingRow(),
              Padding(
                padding: const EdgeInsets.all(currStreakPadding),
                child: Text(
                  "Current Streak:",
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.w100,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(streakPadding),
                child: Text(
                  streak.toString(),
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Color(0xFF1dcaff),
                    fontSize: 120.0,
                    fontWeight: FontWeight.w100,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget followingRow() {
    return Padding(
      padding: const EdgeInsets.all(followagePadding),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
      ),
    );
  }
}
