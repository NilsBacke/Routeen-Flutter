import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:routeen/UI/Login/signup_view.dart';
import 'package:routeen/UI/home_state.dart';
import 'package:flutter/services.dart' show PlatformException;

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
    FirebaseUser user;
    try {
      user = await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } catch (e) {
      print(e.toString());
    } finally {
      if (user != null) {
        var userUpdateInfo = new UserUpdateInfo();
        userUpdateInfo.displayName = nameController.text;
        await _auth.updateProfile(userUpdateInfo);
        await user.reload();
        homePage();
      } else {
        showInValidDialog();
      }
    }
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
    Navigator
        .of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
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
              color: Colors.blue,
              child: new Text("Close"),
              onPressed: null,
            ),
          ],
        );
      },
    );
  }
}
