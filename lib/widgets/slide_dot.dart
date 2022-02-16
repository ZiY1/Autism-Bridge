import 'package:autism_bridge/constants.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SlideDot extends StatelessWidget {
  final bool isActive;
  const SlideDot({Key? key, required this.isActive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 1.2.h),
      height: isActive ? 0.63.h : 0.63.h,
      width: isActive ? 6.5.w : 2.w,
      decoration: BoxDecoration(
        color: isActive ? kAutismBridgeOrange : const Color(0xFFEAEAFF),
        borderRadius: const BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
    );
  }
}
