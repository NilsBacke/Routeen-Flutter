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
      child: MaterialSearchInput(
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
    return Container(
        // child: ListView.builder(),
        );
  }
}
