import 'package:flutter/material.dart';
import 'home_state.dart';

class HomeView extends HomeState {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: const Color(0xFF1dcaff),
        title: new Text("Routeen"),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.edit),
            onPressed: () {
              composePage(context);
            },
          )
        ],
      ),
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
              _taskList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _taskList() {
    return new Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: new Container(
        child: new ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: tasks.length,
          itemBuilder: (BuildContext context, int index) {
            print("list is completed: ${tasks[index].isCompleted}");
            return new Column(
              children: <Widget>[
                new CheckboxListTile(
                  activeColor: const Color(0xFF1dcaff),
                  value: tasks[index].isCompleted == 0 ? false : true,
                  // value: true,
                  onChanged: (val) {
                    alterTask(val, index);
                  },
                  title: new Text(
                    tasks[index].name,
                    // "name",
                  ),
                ),
                new Divider(),
              ],
            );
          },
        ),
      ),
    );
  }
}
