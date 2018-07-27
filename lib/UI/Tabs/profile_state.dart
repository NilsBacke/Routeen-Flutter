import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:routeen/UI/Login/login_state.dart';
import 'package:routeen/UI/Tabs/profile_view.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class Profile extends StatefulWidget {
  @override
  ProfileView createState() => ProfileView();
}

abstract class ProfileState extends State<Profile> {
  logOut() {
    _auth.signOut();
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      Login();
    }));
  }
}
