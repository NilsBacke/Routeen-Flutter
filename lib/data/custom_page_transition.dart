import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomPageTransition extends MaterialPageRoute {
  final Widget destination;
  CustomPageTransition(this.destination)
      : super(builder: (BuildContext context) => destination);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 750);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: destination);
  }
}
