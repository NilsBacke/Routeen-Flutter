import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:routeen/UI/Tabs/following_view.dart';
import 'package:routeen/UI/Tabs/profile_state.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final Firestore db = Firestore.instance;

class Following extends StatefulWidget {
  @override
  FollowingView createState() => FollowingView();
}

abstract class FollowingState extends State<Following> {
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
                  follow(name, uid, email, streak, dayLastCompleted);
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
                "Are you sure you want to remove $name from your Following list?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  removeFollowing(uid);
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

  void follow(String name, String uid, String email, int streak,
      int dayLastCompleted) async {
    String currUserUID = await getUserUID();

    // update current user's "following"
    getFollowingCollection().then((val) {
      val.document(uid).setData({
        'name': name,
        'userUID': uid,
        'email': email,
        'streak': streak,
        'dayLastCompleted': dayLastCompleted
      });
    });
    // update current user's "followingCount"
    await updateFollowingCount(1);

    // update user2's "followers"
    Map map = await getInfoFromUID(currUserUID);
    String currname = map['name'];
    String curremail = map['email'];
    int currdayLastCompleted = map['dayLastCompleted'];
    int currstreak = map['streak'];
    getFollowersCollection(uid).document(currUserUID).setData({
      'name': currname,
      'userUID': currUserUID,
      'email': curremail,
      'streak': currstreak,
      'dayLastCompleted': currdayLastCompleted
    });
    // update user2's "followersCount"
    await updateFollowersCount(uid, 1);
  }

  void removeFollowing(String uid) async {
    WriteBatch batch = db.batch();

    // update current user's "following"
    getFollowingCollection().then((val) async {
      var docs = await val.where('userUID', isEqualTo: uid).getDocuments();
      var list = docs.documents;
      for (DocumentSnapshot snap in list) {
        batch.delete(snap.reference);
      }
    });

    // update user2's "followers"
    String currUserUID = await getUserUID();
    var docs = await getFollowersCollection(uid)
        .where('userUID', isEqualTo: currUserUID)
        .getDocuments();
    var list = docs.documents;
    for (DocumentSnapshot snap in list) {
      batch.delete(snap.reference);
    }

    // delete the documents then update the counts
    batch.commit().then((val) async {
      // update current user's "followingCount" (-1)
      await updateFollowingCount(-1);
      // update user2's "followersCount"
      await updateFollowersCount(uid, -1);
    });
  }

  Future updateFollowingCount(int amount) async {
    final userDoc = await getUserDoc();
    db.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(userDoc);
      var newCount = snapshot.data['followingCount'] + amount;
      transaction.update(userDoc, {"followingCount": newCount});
    });
  }

  Future updateFollowersCount(String uid, int amount) async {
    DocumentReference user2doc = db.collection('users').document(uid);
    db.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(user2doc);
      var newCount = snapshot.data['followersCount'] + amount;
      transaction.update(user2doc, {"followersCount": newCount});
    });
  }

  void showProfilePage(String useruid) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return Profile(
        userUID: useruid,
      );
    }));
  }

  Future<DocumentReference> getUserDoc() async {
    final useruid = await getUserUID();
    return db.collection('users').document(useruid);
  }

  Future<String> getUserUID() async {
    String currUserUID;
    if (userUID == '') {
      currUserUID = await getUserUIDFromAuth();
    } else {
      currUserUID = userUID;
    }
    return currUserUID;
  }

  Future<String> getUserUIDFromAuth() async {
    var user = await _auth.currentUser();
    return user.uid;
  }

  Future<CollectionReference> getFollowingCollection() async {
    var useruid = await getUserUID();
    return db.collection('users').document(useruid).collection('following');
  }

  CollectionReference getFollowersCollection(String useruid) {
    return db.collection('users').document(useruid).collection('followers');
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
    List<User> following = await getFollowingList();
    for (DocumentSnapshot snap in list) {
      var map = snap.data;
      if (userUID != map['userUID'] && !inFollowingList(following, map)) {
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

  getFollowingList() async {
    List<User> following = List();
    var ref = await getFollowingCollection();
    var snap = await ref.getDocuments();
    var docs = snap.documents;
    for (DocumentSnapshot doc in docs) {
      var data = doc.data;
      following.add(User(
          name: data['name'],
          userUID: data['userUID'],
          email: data['email'],
          currStreak: data['streak'],
          dayLastCompleted: data['dayLastCompleted']));
    }
    return following;
  }

  Future setUserUID() async {
    var _userUID = await getUserUID();
    if (this.mounted) {
      setState(() {
        userUID = _userUID;
      });
    }
  }

  bool inFollowingList(List<User> following, Map<String, dynamic> map) {
    var uid = map['userUID'];
    for (int i = 0; i < following.length; i++) {
      if (following[i].userUID == uid) {
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
