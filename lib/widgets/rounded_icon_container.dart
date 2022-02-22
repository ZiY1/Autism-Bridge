import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RoundedIconContainer extends StatelessWidget {
  final Widget childIcon;

  final Function() onPressed;

  final Color color;

  final EdgeInsetsGeometry margin;

  const RoundedIconContainer({
    Key? key,
    required this.childIcon,
    required this.onPressed,
    required this.color,
    required this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 3.8.h,
        height: 3.8.h,
        child: childIcon,
        margin: margin,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
