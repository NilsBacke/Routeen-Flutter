import 'package:flutter/material.dart';
import 'package:routeen/UI/Login/signup_state.dart';
import 'login_view.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginView();
}

abstract class LoginState extends State<Login> {
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
}
