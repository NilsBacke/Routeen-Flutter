import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:routeen/UI/Login/login_state.dart';
import 'package:routeen/UI/Tabs/profile_view.dart';

final Firestore db = Firestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class Profile extends StatefulWidget {
  @override
  ProfileView createState() => ProfileView();
}

abstract class ProfileState extends State<Profile> {
  String name = '';
  String email = '';
  int following = 0;
  int followers = 0;
  int streak = 0;

  @override
  initState() {
    super.initState();
  }

  void logOut() {
    _auth.signOut();
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      Login();
    }));
  }

  void setUserName() async {
    var snap = await getUserSnap();
    name = snap.data['name'];
  }

  void setUserEmail() async {
    var snap = await getUserSnap();
    email = snap.data['email'];
  }

  void setUserFollowing() async {
    var snap = await getUserSnap();
    name = snap.data['name'];
  }

  void setUserFollowers() async {
    var snap = await getUserSnap();
    name = snap.data['name'];
  }

  void setUserStreak() async {
    var snap = await getUserSnap();
    streak = snap.data['streak'];
  }

  Future<DocumentSnapshot> getUserSnap() async {
    var useruid = await getUserUID();
    return db.collection('users').document(useruid).get();
  }

  Future<String> getUserUID() async {
    var user = await _auth.currentUser();
    return user.uid;
  }
}
