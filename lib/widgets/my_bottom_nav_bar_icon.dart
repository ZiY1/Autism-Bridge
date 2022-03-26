import 'package:flutter/material.dart';

import '../color_constants.dart';

class MyBottomNavBarIcon extends StatelessWidget {
  final bool isSelected;
  final Function()? onPressed;
  final String iconPath;
  final double scale;
  const MyBottomNavBarIcon({
    Key? key,
    required this.isSelected,
    required this.onPressed,
    required this.iconPath,
    required this.scale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Image.asset(
        iconPath,
        scale: scale,
        color: isSelected ? kAutismBridgeBlue : const Color(0xFFB8B8D2),
      ),
    );
  }
}
