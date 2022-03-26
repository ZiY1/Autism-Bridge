import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../color_constants.dart';

class MyBottomNavBarLabel extends StatelessWidget {
  final bool isSelected;
  final Function()? onPressed;
  final String labelName;

  const MyBottomNavBarLabel({
    Key? key,
    required this.isSelected,
    required this.onPressed,
    required this.labelName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Text(
        labelName,
        style: TextStyle(
          fontSize: 9.sp,
          color: isSelected ? kAutismBridgeBlue : const Color(0xFFB8B8D2),
        ),
      ),
    );
  }
}
