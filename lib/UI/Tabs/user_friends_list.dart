import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:routeen/UI/Tabs/profile_state.dart';
import 'package:routeen/UI/Tabs/user_list_item.dart';
import 'package:routeen/data/data.dart';

final Firestore db = Firestore.instance;

class UserList extends StatefulWidget {
  final String userUID;
  final String collectionName;

  UserList({this.userUID, this.collectionName});

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
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
              capitalizeFirstLetter(widget.collectionName),
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
          _buildBody(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      padding: EdgeInsets.only(top: getTopPadding(context)),
      child: StreamBuilder(
        stream: db
            .collection('users')
            .document(widget.userUID)
            .collection(widget.collectionName)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          print(snapshot.data.documents.length);
          return ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index) {
              var document = snapshot.data.documents[index];
              return UserListItem(
                title: Text(document.data['name'].toString()),
                trailing: document.data['streak'].toString(),
                color: Colors.lightBlue[300],
                onTap: () {
                  showProfilePage(document.data['userUID']);
                },
              );
            },
          );
        },
      ),
    );
  }

  void showProfilePage(String useruid) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return Profile(
        userUID: useruid,
      );
    }));
  }

  String capitalizeFirstLetter(String s) {
    return s[0].toUpperCase() + s.substring(1);
  }
}
