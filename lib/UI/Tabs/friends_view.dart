import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:routeen/UI/Tabs/friends_state.dart';
import 'package:material_search/material_search.dart';
import 'package:routeen/data/my_material_search_result.dart';

class FriendsView extends FriendsState {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            buildSearchBar(),
            buildFriendsList(),
          ],
        ),
      ),
    );
  }

  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: MaterialSearchInput<String>(
        placeholder: "Search people...",
        results: usersList
            .map((user) => new MyMaterialSearchResult<String>(
                  value: user.userUID,
                  text: user.name,
                  icon: Icons.person,
                  subtext: user.email,
                ))
            .toList(),
        onSelect: showFriendDialog,
      ),
    );
  }

  Widget buildFriendsList() {
    return Expanded(
      child: StreamBuilder(
        stream: db.collection('users').snapshots(), // fix to user's friends
        builder: (_, AsyncSnapshot<dynamic> snapshot) {
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
    return Column(
      children: <Widget>[
        ListTile(),
      ],
    );
  }
}
