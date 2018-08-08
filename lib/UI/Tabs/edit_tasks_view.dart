import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:routeen/data/data.dart';
import 'edit_tasks_state.dart';

class EditTasksView extends EditTasksState {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: getTopPadding(context)),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
            ),
            _addTaskField(),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
            ),
            _tasksList(),
          ],
        ),
      ),
    );
  }

  Widget _addTaskField() {
    const multiplier = 0.55;
    var textFieldWidth = MediaQuery.of(context).size.width * multiplier;
    print('num tasks: $numTasks');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: numTasks == 0
          ? _newUserTextfieldAndButton(textFieldWidth)
          : _textfieldAndButton(textFieldWidth),
    );
  }

  Widget _textfieldAndButton(double textFieldWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: textFieldWidth,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "Brush teeth",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        RaisedButton(
          color: const Color(0xFF1dcaff),
          onPressed: addTaskToList,
          child: Text("Add"),
        ),
      ],
    );
  }

  Widget _newUserTextfieldAndButton(double textFieldWidth) {
    return Container(
      height: 300.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: textFieldWidth,
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: "Brush teeth",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              RaisedButton(
                color: const Color(0xFF1dcaff),
                onPressed: addTaskToList,
                child: Text("Add"),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Center(
                  child: Text(
                    "Type your new task in here",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                child: Center(
                  child: Text(
                    "And press here to add it to the list",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tasksList() {
    if (userUID == '') {
      return Expanded(child: Center(child: CircularProgressIndicator()));
    }
    return Expanded(
      child: StreamBuilder(
        stream: db
            .collection('users')
            .document(userUID)
            .collection('tasks')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
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
    return Column(
      children: <Widget>[
        Dismissible(
          key: Key(document['name']),
          background: Container(
            color: Colors.red,
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.delete_outline),
                Icon(Icons.delete_outline),
              ],
            ),
          ),
          onDismissed: (direction) {
            removeTask(context, document.documentID);
          },
          child: ListTile(
            title: Text(document['name']),
          ),
        ),
        Divider(),
      ],
    );
  }
}
