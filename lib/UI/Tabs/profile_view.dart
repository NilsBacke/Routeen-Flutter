import 'package:flutter/material.dart';
import 'package:routeen/UI/Tabs/profile_state.dart';
import 'package:routeen/data/data.dart';

const profPicPadding = 16.0;
const namePadding = 12.0;
const emailPadding = 12.0;
const followagePadding = 12.0;
const currStreakPadding = 8.0;
const streakPadding = 4.0;

class ProfileView extends ProfileState {
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (widget.userUID != null) {
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
            ),
            _buildBody(context)
          ],
        ),
      );
    }
    return _buildBody(context);
  }

  Container _buildBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: getTopPadding(context)),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(namePadding),
                child: Hero(
                  tag: name,
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.w100,
                      color: Colors.white,
                    ),
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
                    fontSize: 140.0,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            child: Column(
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
                  following.toString(),
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            onTap: followingPage,
          ),
          GestureDetector(
            child: Column(
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
                  followers.toString(),
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            onTap: followersPage,
          ),
        ],
      ),
    );
  }
}
