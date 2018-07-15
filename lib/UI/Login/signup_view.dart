import 'package:flutter/material.dart';
import 'package:routeen/UI/Login/signup_state.dart';

class SignUpView extends SignUpState {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: new Text("Sign up"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Center(
          child: Form(
            key: formKey,
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    nameFormField(),
                    emailFormField(),
                    passwordFormField(),
                    signUpButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding nameFormField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: nameController,
        validator: nameValidator,
        decoration: InputDecoration(
          hintText: 'Full name',
          contentPadding: EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
      ),
    );
  }

  Padding emailFormField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: emailController,
        validator: emailValidator,
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
      obscureText: true,
      controller: passwordController,
      validator: passwordValidator,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
  }

  Padding signUpButton() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: signUpUser,
          color: Colors.lightBlueAccent,
          child: Text('Sign up', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
