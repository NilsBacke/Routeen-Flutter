import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:routeen/UI/Tabs/profile_view.dart';
import 'package:routeen/UI/Tabs/user_friends_list.dart';

final Firestore db = Firestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class Profile extends StatefulWidget {
  final String userUID;

  const Profile({this.userUID});

  @override
  ProfileView createState() => ProfileView();
}

abstract class ProfileState extends State<Profile> {
  String name;
  String email;
  int following;
  int followers;
  int streak;
  bool isLoading = true;

  @override
  Profile get widget => super.widget;

  @override
  initState() {
    super.initState();
    setUserInfo();
  }

  void setUserInfo() async {
    var snap = await getUserSnap();
    if (name == null) {
      setState(() {
        name = snap.data['name'];
        email = snap.data['email'];
        streak = snap.data['streak'];
        following = snap.data['followingCount'];
        followers = snap.data['followersCount'];
        isLoading = false;
      });
    }
  }

  void followingPage() {
    goToPage('following');
  }

  void followersPage() {
    goToPage('followers');
  }

  void goToPage(String pageName) async {
    var useruid = widget.userUID;
    if (widget.userUID == null) {
      useruid = await getUserUID();
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return UserList(userUID: useruid, collectionName: pageName);
    }));
  }

  Future<DocumentSnapshot> getUserSnap() async {
    var useruid = widget.userUID;
    if (widget.userUID == null) {
      useruid = await getUserUID();
    }
    return db.collection('users').document(useruid).get();
  }

  Future<String> getUserUID() async {
    var user = await _auth.currentUser();
    return user.uid;
  }
}
