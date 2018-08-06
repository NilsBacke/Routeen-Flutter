import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

double getTopPadding(context) {
  return MediaQuery.of(context).padding.top + 50;
}

Future addUserToDB(Firestore db, FirebaseUser user, String name) async {
  Map<String, Object> userMap = new Map();
  userMap["name"] = name;
  userMap["streak"] = 0;
  userMap["email"] = user.email;
  userMap["dayLastCompleted"] = getToday() - 1;
  userMap['userUID'] = user.uid;
  userMap['followingCount'] = 0;
  userMap['followersCount'] = 0;
  db.collection('users').document(user.uid).setData(userMap).then((val) {
    print("user added");
  });
}

/// returns an int that represents the day of the month
int getToday() {
  DateTime today = DateTime.now();
  return today.day; // an integer
}
