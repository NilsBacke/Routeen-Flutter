import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'edit_tasks_state.dart';

class EditTasksView extends EditTasksState {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.all(12.0),
            ),
            _addTaskField(),
            new Padding(
              padding: const EdgeInsets.only(top: 16.0),
            ),
            _tasksList(),
          ],
        ),
      ),
    );
  }

  Widget _addTaskField() {
    return new Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Container(
            width: 200.0,
            child: new TextField(
              controller: controller,
              decoration: new InputDecoration(
                hintText: "Brush teeth",
                border: new OutlineInputBorder(),
              ),
            ),
          ),
          new RaisedButton(
            color: const Color(0xFF1dcaff),
            onPressed: addTaskToList,
            child: new Text("Add"),
          ),
        ],
      ),
    );
  }

  Widget _tasksList() {
    if (userUID == '') {
      return Expanded(child: Center(child: Text("Loading...")));
    }
    return new Expanded(
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
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildListItem(
                  index, context, snapshot.data.documents[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildListItem(
      int index, BuildContext context, DocumentSnapshot document) {
    return new Dismissible(
      key: Key(document['name']),
      background: Container(
        color: Colors.red,
        padding: const EdgeInsets.all(12.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Icon(Icons.delete_outline),
            new Icon(Icons.delete_outline),
          ],
        ),
      ),
      onDismissed: (direction) {
        removeTask(context, document.documentID);
      },
      child: new Column(
        children: <Widget>[
          new ListTile(
            title: new Text(document['name']),
          ),
          new Divider(),
        ],
      ),
    );
  }
}
