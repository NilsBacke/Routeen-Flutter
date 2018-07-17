import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'home_state.dart';

class HomeView extends HomeState {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SingleChildScrollView(
        child: new Center(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Text(
                streak.toString(),
                style: new TextStyle(
                  fontSize: 150.0,
                  color: const Color(0xFF1dcaff),
                  fontWeight: FontWeight.w100,
                ),
              ),
              new Text(
                "Day Streak",
                style: new TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.w200,
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(6.0),
              ),
              new Text(
                motivationText,
                style: new TextStyle(
                  fontSize: 35.0,
                  fontWeight: FontWeight.w200,
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(6.0),
              ),
              new Align(
                alignment: Alignment.centerLeft,
                child: new Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: new Text(
                    "Today's Tasks:",
                    style: new TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ),
              ),
              _tasksList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tasksList() {
    if (userUID == '') {
      return Center(child: Text("Loading..."));
    }
    return new Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: new Container(
        child: StreamBuilder(
          stream: db
              .collection('users')
              .document(userUID)
              .collection('tasks')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Text("Loading..."));
            }
            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildListItem(
                    index, context, snapshot.data.documents[index]);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildListItem(
      int index, BuildContext context, DocumentSnapshot document) {
    return new Column(
      children: <Widget>[
        new CheckboxListTile(
          activeColor: const Color(0xFF1dcaff),
          value: document['isCompleted'],
          // value: true,
          onChanged: (val) {
            alterTask(val, document);
          },
          title: new Text(
            document['name'],
          ),
        ),
        new Divider(),
      ],
    );
  }
}
