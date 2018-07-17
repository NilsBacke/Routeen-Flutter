import 'package:flutter/material.dart';
import 'package:routeen/UI/Tabs/friends_state.dart';
import 'package:material_search/material_search.dart';

class FriendsView extends FriendsState {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MaterialSearch(
      placeholder: "John Doe",
    ));
  }
}
