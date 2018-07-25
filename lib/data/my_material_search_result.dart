import 'package:flutter/material.dart';
import 'package:material_search/material_search.dart';

class MyMaterialSearchResult<T> extends MaterialSearchResult<T> {
  const MyMaterialSearchResult(
      {Key key, this.value, this.text, this.icon, this.subtext})
      : super(key: key, value: value, text: text, icon: icon);

  final T value;
  final String text;
  final String subtext;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(icon),
            title: Text(value.toString()),
            subtitle: Text(subtext),
          ),
          Divider(),
        ],
      ),
    );
  }
}
