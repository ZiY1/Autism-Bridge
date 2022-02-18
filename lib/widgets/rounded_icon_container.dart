import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RoundedIconContainer extends StatelessWidget {
  final Widget childIcon;

  final Function() onPressed;

  const RoundedIconContainer({
    Key? key,
    required this.childIcon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 3.8.h,
        height: 3.8.h,
        child: childIcon,
        margin: EdgeInsets.only(top: 1.2.h, bottom: 1.2.h, right: 0.6.h),
        decoration: BoxDecoration(
          color: const Color(0xFF000000).withOpacity(0.05),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
