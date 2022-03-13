import 'package:flutter/material.dart';

import '../constants.dart';

class MyGradientContainer extends StatelessWidget {
  final Widget child;
  const MyGradientContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [
            0.01,
            0.35,
          ],
          colors: [
            kAutismBridgeLightBlue,
            //kAutismBridgeBlue,
            kBackgroundRiceWhite,
          ],
        ),
      ),
      child: child,
    );
  }
}
