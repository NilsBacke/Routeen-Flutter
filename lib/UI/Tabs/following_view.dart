import 'package:flutter/material.dart';
import 'package:routeen/UI/Tabs/following_state.dart';
import 'package:material_search/material_search.dart';
import 'package:routeen/UI/Tabs/user_list_item.dart';
import 'package:routeen/data/data.dart';
import 'package:routeen/data/my_material_search_result.dart';

class FollowingView extends FollowingState {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: getTopPadding(context)),
      child: Container(
        child: Column(
          children: <Widget>[
            buildSearchBar(),
            buildFollowingList(),
          ],
        ),
      ),
    );
  }

  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: MaterialSearchInput<String>(
        placeholder: "Find people...",
        results: usersList
            .map((user) => new MyMaterialSearchResult<String>(
                  text: user.name,
                  value: user.userUID,
                  icon: Icons.person,
                  subtext: user.email,
                ))
            .toList(),
        onSelect: (uid) {
          print(uid);
          showFriendDialog(uid);
        },
      ),
    );
  }

  Widget buildFollowingList() {
    if (userUID == '') {
      return Expanded(child: Center(child: CircularProgressIndicator()));
    }
    return Expanded(
      child: StreamBuilder(
        stream: db
            .collection('users')
            .document(userUID)
            .collection('following')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          print(snapshot.data.documents.length);
          return ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index) {
              var document = snapshot.data.documents[index];
              return UserListItem(
                title: Hero(
                  tag: document.data['name'].toString(),
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      document.data['name'].toString(),
                      style: TextStyle(
                        color: index >= colorList.length
                            ? Colors.black
                            : colorList[index],
                      ),
                    ),
                  ),
                ),
                trailing: Text(
                  "Current streak: ${document.data['streak'].toString()}",
                  style: TextStyle(
                      fontSize: 18.0,
                      color: index >= colorList.length
                          ? Colors.black
                          : colorList[index]),
                ),
                color: Colors.lightBlue[300],
                onTap: () {
                  showProfilePage(
                      document.data['userUID'], document.data['name']);
                },
                onLongPress: () {
                  showRemoveDialog(
                      document.data['name'], document.data['userUID']);
                },
              );
            },
          );
        },
      ),
    );
  }
}
