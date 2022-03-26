import 'package:flutter/material.dart';
import '../num_constants.dart';

class MyCardWidget extends StatelessWidget {
  final Widget child;

  const MyCardWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(kCardRadius)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8A959E).withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 30.0,
            //offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: child,
    );
  }
}
