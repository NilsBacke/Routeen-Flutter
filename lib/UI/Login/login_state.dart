import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:routeen/UI/Login/signup_state.dart';
import 'package:routeen/UI/home_state.dart';
import 'login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignin = new GoogleSignIn();

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginView();
}

abstract class LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  logIn() async {
    if (formKey.currentState.validate()) {
      await signInWithEmail();
    }
  }

  signInWithEmail() async {
    FirebaseUser user;
    try {
      user = await _auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      print("done logging in");
      print(user.uid);

      print("new user set");
      return user;
    } catch (err) {
      print(err.toString());
    } finally {
      if (user != null) {
        //Log in was successfull
        print(user.email);
        homePage();
      } else {
        //Log in was unsuccessfull
        showInValidDialog();
      }
    }
  }

  handleGoogleSignIn() async {
    GoogleSignInAccount googleUser = await _googleSignin.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    print("signed in " + user.displayName);
    homePage();
  }

  /// checks if the given email is valid
  String emailValidator(String val) {
    if (val.isEmpty || !val.contains("@")) {
      return "Please enter a valid email address.";
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

  signUpPage() {
    Navigator
        .of(context)
        .push(MaterialPageRoute(builder: (context) => SignUp()));
  }

  dragSignUpPage(DragEndDetails details) {
    if (details.primaryVelocity == 0)
      return; // user have just tapped on screen (no dragging)
    if (details.primaryVelocity.compareTo(0) == -1) {
      print('dragged from left');
      signUpPage();
    } else {
      print('dragged from right');
    }
  }

  void showInValidDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text("Invalid Login!"),
          content: new Text(
              "Please provide a valid email and password combination."),
          actions: <Widget>[
            new FlatButton(
              color: Colors.lightBlue,
              child: new Text("Sign Up For New Account"),
              onPressed: signUpPage(),
            ),
            new FlatButton(
              color: Colors.lightBlue,
              child: new Text("Close"),
              onPressed: null,
            ),
          ],
        );
      },
    );
  }
}
