import 'package:flutter/material.dart';
import 'home_state.dart';
import 'edit_tasks_state.dart';

class HomePageView extends HomeState {
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
              Navigator
                  .of(context)
                  .push(MaterialPageRoute(builder: (context) => EditTasks()));
            },
          )
        ],
      ),
      body: new Center(
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
              keepItUp,
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
                padding: const EdgeInsets.all(8.0),
                child: new Text(
                  "Today's Tasks:",
                  style: new TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
            ),
            new Expanded(
              child: _taskList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _taskList() {
    return new Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: new Container(
        child: new ListView.builder(
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) {
            return new Column(
              children: <Widget>[
                new CheckboxListTile(
                  activeColor: const Color(0xFF1dcaff),
                  value: isCompletedValues[index],
                  onChanged: (val) {
                    alterTask(val, index);
                  },
                  title: new Text(
                    "Name",
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
