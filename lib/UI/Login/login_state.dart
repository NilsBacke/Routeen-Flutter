import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:routeen/UI/Login/signup_state.dart';
import 'package:routeen/UI/tab_home.dart';
import 'package:routeen/data/data.dart';
import 'login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final Firestore _db = Firestore.instance;
final GoogleSignIn _googleSignin = new GoogleSignIn();

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginView();
}

abstract class LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    getUser().then((user) {
      if (user != null) {
        homePage();
      }
    });
  }

  Future<FirebaseUser> getUser() async {
    return await _auth.currentUser();
  }

  logInPressed() async {
    if (formKey.currentState.validate()) {
      signInWithEmail();
    }
  }

  void signInWithEmail() async {
    FirebaseUser user;
    try {
      user = await _auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } catch (e) {
      print(e.toString());
    } finally {
      if (user != null) {
        homePage();
      } else {
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
    await addUserToDB(_db, user, user.displayName);
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
    if (val.isEmpty) {
      return "Please enter a valid password.";
    }
    return null;
  }

  homePage() {
    Navigator
        .of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => TabBarHome()));
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
