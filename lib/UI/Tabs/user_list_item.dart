import 'package:flutter/material.dart';

class UserListItem extends StatefulWidget {
  final Widget title;
  final Widget trailing;
  final Color color;
  final GestureTapCallback onTap;
  final GestureLongPressCallback onLongPress;

  UserListItem(
      {this.title, this.trailing, this.color, this.onTap, this.onLongPress});

  @override
  _UserListItemState createState() => _UserListItemState();
}

class _UserListItemState extends State<UserListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        color: widget.color,
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(
              border: new Border(
                right: new BorderSide(width: 1.5, color: Colors.white24),
              ),
            ),
            child: Icon(Icons.person_outline, color: Colors.black),
          ),
          title: widget.title,
          trailing: widget.trailing,
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
        ),
      ),
    );
  }
}
