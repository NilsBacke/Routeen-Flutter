import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:routeen/UI/Tabs/friends_view.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final Firestore db = Firestore.instance;

class Friends extends StatefulWidget {
  @override
  FriendsView createState() => FriendsView();
}

abstract class FriendsState extends State<Friends> {
  List<User> usersList = List();
  String userUID = '';

  @override
  initState() {
    super.initState();
    fillUsersList(); // sets the userUID
  }

  @override
  dispose() {
    super.dispose();
  }

  /// show a dialog that prompts the user to confirm adding the selection as a friend
  void showFriendDialog(String uid) async {
    String name = await getNameFromUID(uid);
    int currStreak = await getStreakFromUID(uid);
    if (name == null) return;
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("Add friend"),
            content: Text("Are you sure you want to add $name as a friend?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  addFriend(name, uid, currStreak);
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void addFriend(String name, String uid, int streak) async {
    getFriendsCollection().then((val) {
      val.add({'name': name, 'userUID': uid, 'streak': streak});
    });
  }

  Future<String> getUserUID() async {
    var user = await _auth.currentUser();
    return user.uid;
  }

  Future<CollectionReference> getFriendsCollection() async {
    var useruid = await getUserUID();
    return db.collection('users').document(useruid).collection('friends');
  }

  Future<String> getNameFromUID(String uid) async {
    var docs = await db
        .collection("users")
        .where('userUID', isEqualTo: uid)
        .getDocuments();
    var list = docs.documents;
    for (DocumentSnapshot snap in list) {
      return snap.data['name'];
    }
    return null;
  }

  Future<int> getStreakFromUID(String uid) async {
    var docs = await db
        .collection("users")
        .where('userUID', isEqualTo: uid)
        .getDocuments();
    var list = docs.documents;
    for (DocumentSnapshot snap in list) {
      return snap.data['streak'];
    }
    return null;
  }

  void fillUsersList() async {
    var docs = await db.collection('users').getDocuments();
    var list = docs.documents;
    await setUserUID();
    for (DocumentSnapshot snap in list) {
      var map = snap.data;
      if (userUID != map['userUID']) {
        // don't add the current user to users list
        usersList.add(
            User(map['name'], map['email'], map['userUID'], map['streak']));
      }
    }
  }

  Future setUserUID() async {
    var _userUID = await getUserUID();
    if (this.mounted) {
      setState(() {
        userUID = _userUID;
      });
    }
  }
}

class User {
  User(this.name, this.email, this.userUID, this.currStreak);
  String name, email, userUID;
  int currStreak;
}
