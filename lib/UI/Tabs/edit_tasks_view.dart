import 'package:flutter/material.dart';
import 'edit_tasks_state.dart';

class EditTasksView extends EditTasksState {
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text("Routeen"),
          centerTitle: true,
          backgroundColor: const Color(0xFF1dcaff),
        ),
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
      ),
      onWillPop: () {
        Navigator.pop(context, tasks);
      },
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
    return new Expanded(
      child: new ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (BuildContext context, int index) {
          return new Dismissible(
            key: Key(tasks[index].id.toString()),
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
              removeTask(context, index);
            },
            child: new Column(
              children: <Widget>[
                new ListTile(
                  title: new Text(tasks[index].name),
                ),
                new Divider(),
              ],
            ),
          );
        },
      ),
    );
  }
}
