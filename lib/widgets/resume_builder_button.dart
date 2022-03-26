import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../color_constants.dart';
import '../num_constants.dart';

class ResumeBuilderButton extends StatelessWidget {
  final Function()? onPressed;
  final Widget child;
  final bool isHollow;
  final bool? disableBorder;

  const ResumeBuilderButton({
    Key? key,
    required this.onPressed,
    required this.child,
    required this.isHollow,
    this.disableBorder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          child,
        ],
      ),
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.all(1.55.h),
        ),
        backgroundColor: isHollow
            ? null
            : MaterialStateProperty.all<Color>(
                kAutismBridgeBlue,
              ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kCardRadius),
          ),
        ),
        side: isHollow
            ? MaterialStateProperty.all<BorderSide>(
                BorderSide(
                  color: disableBorder == true
                      ? Colors.transparent
                      : kAutismBridgeBlue,
                ),
              )
            : null,
      ),
      onPressed: onPressed,
    );
  }
}
