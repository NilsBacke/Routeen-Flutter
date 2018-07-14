import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:routeen/UI/Login/signup_view.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignUp extends StatefulWidget {
  @override
  SignUpView createState() => SignUpView();
}

abstract class SignUpState extends State<SignUp> {
  void createUser() async {
    FirebaseUser user = await _auth
        .createUserWithEmailAndPassword(
      email: "nils.backe@gmail.com",
      password: "test12345",
    )
        .then((user) {
      print("Email: ${user.email}");
    });
  }
}
