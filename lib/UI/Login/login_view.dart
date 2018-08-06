import 'package:flutter/material.dart';
import 'login_state.dart';

class LoginView extends LoginState {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        constraints: BoxConstraints.expand(),
        child: GestureDetector(
          onHorizontalDragEnd: (DragEndDetails details) {
            dragSignUpPage(details);
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Stack(
              children: <Widget>[
                Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: <Widget>[
                        titleText(),
                        emailFormField(),
                        passwordFormField(),
                        logInButton(),
                        signInWithGoogleButton(),
                      ],
                    ),
                  ),
                ),
                signUpButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget titleText() {
    const multiplier = 0.324;
    var titleHeight = MediaQuery.of(context).size.height * multiplier;

    return Container(
      height: titleHeight,
      child: Center(
        child: Text(
          "Routeen",
          style: TextStyle(
            color: Colors.lightBlueAccent,
            fontSize: 50.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Padding emailFormField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        validator: emailValidator,
        controller: emailController,
        decoration: InputDecoration(
          hintText: 'Email',
          contentPadding: EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
      ),
    );
  }

  TextFormField passwordFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      validator: passwordValidator,
      controller: passwordController,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
  }

  Padding logInButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: logInPressed,
          color: Colors.lightBlueAccent,
          child: Text('Log In', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget signInWithGoogleButton() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: MaterialButton(
        onPressed: handleGoogleSignIn,
        color: Colors.grey[100],
        elevation: 0.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              "img/glogo.png",
              height: 18.0,
              width: 18.0,
            ),
            SizedBox(width: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Sign in with Google",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget signUpButton() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Don't have an account yet?"),
            FlatButton(
              child: Text(
                "Sign up",
                style: TextStyle(color: Colors.lightBlue),
              ),
              onPressed: () {
                signUpPage();
              },
            ),
          ],
        ),
      ),
    );
  }
}
