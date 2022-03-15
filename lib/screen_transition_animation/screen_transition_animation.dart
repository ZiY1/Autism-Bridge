import 'package:flutter/material.dart';

class ScreenTransitionAnimation {
  static Route createBackRoute({required Widget destScreen}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => destScreen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
