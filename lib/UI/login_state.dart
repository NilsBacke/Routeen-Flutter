import 'package:flutter/material.dart';
import 'login_view.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginView();
}

abstract class LoginState extends State<Login> {}
