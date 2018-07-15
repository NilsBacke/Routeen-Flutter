import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:routeen/UI/Login/signup_view.dart';
import 'package:routeen/UI/home_state.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignUp extends StatefulWidget {
  @override
  SignUpView createState() => SignUpView();
}

abstract class SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  void signUpUser() async {
    if (formKey.currentState.validate()) {
      await signUpWithEmail();
      homePage();
    }
  }

  signUpWithEmail() async {
    FirebaseUser user = await _auth.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );

    var userUpdateInfo = new UserUpdateInfo();
    userUpdateInfo.displayName = nameController.text;
    await _auth.updateProfile(userUpdateInfo);
    await user.reload();
    print("Email: ${user.email}");
  }

  String nameValidator(String val) {
    if (val.isEmpty) {
      return "Please enter a valid name.";
    }
    return null;
  }

  /// checks if the given email is valid
  String emailValidator(String val) {
    if (val.isEmpty || !val.contains("@")) {
      return "Please enter a valid email.";
    }
    return null;
  }

  /// checks if the given password is valid
  String passwordValidator(String val) {
    if (val.isEmpty || val.length < 7) {
      return "Password must be at least 7 characters.";
    }
    return null;
  }

  homePage() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home()));
  }
}
