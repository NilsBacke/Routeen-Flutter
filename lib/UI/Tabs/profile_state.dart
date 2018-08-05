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
  String name;
  String email;
  int following;
  int followers;
  int streak;
  bool isLoading = true;

  @override
  initState() {
    super.initState();
    setUserInfo();
  }

  void logOut() {
    _auth.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
      Login();
    }));
  }

  void setUserInfo() async {
    var snap = await getUserSnap();
    if (name == null) {
      setState(() {
        name = snap.data['name'];
        email = snap.data['email'];
        streak = snap.data['streak'];
        isLoading = false;
      });
    }
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
