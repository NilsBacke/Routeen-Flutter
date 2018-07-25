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

  /// show a dialog that prompts the user to confirm adding the selection as a friend
  void showFriendDialog(String uid) async {
    Map map = await getInfoFromUID(uid);
    String name = map['name'];
    String email = map['email'];
    int dayLastCompleted = map['dayLastCompleted'];
    int streak = map['streak'];
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
                  addFriend(name, uid, email, streak, dayLastCompleted);
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void showRemoveDialog(String name, String uid) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("Remove friend"),
            content: Text(
                "Are you sure you want to remove $name from your friends list?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  removeFriend(uid);
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void addFriend(String name, String uid, String email, int streak,
      int dayLastCompleted) async {
    getFriendsCollection().then((val) {
      val.add({
        'name': name,
        'userUID': uid,
        'email': email,
        'streak': streak,
        'dayLastCompleted': dayLastCompleted
      });
    });
  }

  void removeFriend(String uid) async {
    getFriendsCollection().then((val) async {
      var docs = await val.where('userUID', isEqualTo: uid).getDocuments();
      var list = docs.documents;
      for (DocumentSnapshot snap in list) {
        snap.reference.delete();
      }
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

  Future<Map<String, dynamic>> getInfoFromUID(String uid) async {
    var docs = await db
        .collection("users")
        .where('userUID', isEqualTo: uid)
        .getDocuments();
    var list = docs.documents;
    for (DocumentSnapshot snap in list) {
      return snap.data;
    }
    return null;
  }

  void fillUsersList() async {
    var docs = await db.collection('users').getDocuments();
    var list = docs.documents;
    await setUserUID();
    List<User> friends = await getFriendsList();
    for (DocumentSnapshot snap in list) {
      var map = snap.data;
      if (userUID != map['userUID'] && !inFriendsList(friends, map)) {
        // don't add the current user to users list, or a friend of the current user
        usersList.add(User(
            name: map['name'],
            email: map['email'],
            userUID: map['userUID'],
            currStreak: map['streak'],
            dayLastCompleted: map['dayLastCompleted']));
      }
    }
  }

  getFriendsList() async {
    List<User> friends = List();
    var ref = await getFriendsCollection();
    var snap = await ref.getDocuments();
    var docs = snap.documents;
    for (DocumentSnapshot doc in docs) {
      var data = doc.data;
      friends.add(User(
          name: data['name'],
          userUID: data['userUID'],
          email: data['email'],
          currStreak: data['streak'],
          dayLastCompleted: data['dayLastCompleted']));
    }
    return friends;
  }

  Future setUserUID() async {
    var _userUID = await getUserUID();
    if (this.mounted) {
      setState(() {
        userUID = _userUID;
      });
    }
  }

  bool inFriendsList(List<User> friends, Map<String, dynamic> map) {
    var uid = map['userUID'];
    for (int i = 0; i < friends.length; i++) {
      if (friends[i].userUID == uid) {
        return true;
      }
    }
    return false;
  }
}

class User {
  User(
      {this.name,
      this.email,
      this.userUID,
      this.currStreak,
      this.dayLastCompleted});
  String name, email, userUID;
  int currStreak, dayLastCompleted;
}
