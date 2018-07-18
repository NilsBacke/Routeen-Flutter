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

  @override
  initState() {
    super.initState();
    fillUsersList();
  }

  /// show a dialog that prompts the user to confirm adding the selection as a friend
  void showFriendDialog(String uid) async {
    String name = await getNameFromUID(uid);
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
                  addFriend(name, uid);
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

  void addFriend(String name, String uid) async {
    getFriendsCollection().then((val) {
      val.add({'name': name, 'userUID': uid});
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

  void fillUsersList() async {
    var docs = await db.collection('users').getDocuments();
    var list = docs.documents;
    for (DocumentSnapshot snap in list) {
      var map = snap.data;
      usersList.add(User(map['name'], map['email'], map['userUID']));
    }
  }
}

class User {
  User(this.name, this.email, this.userUID);
  String name, email, userUID;
}
