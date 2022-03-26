import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../color_constants.dart';

class MyBottomNavBarIndicator extends StatelessWidget {
  final bool isSelected;
  const MyBottomNavBarIndicator({
    Key? key,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4.h,
      height: 0.35.h,
      color: isSelected ? kAutismBridgeBlue : Colors.transparent,
    );
  }
}
