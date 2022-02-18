import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../constants.dart';

class ResumeBuilderButton extends StatelessWidget {
  final Function()? onPressed;
  final Widget child;
  final bool isHollow;

  const ResumeBuilderButton({
    Key? key,
    required this.onPressed,
    required this.child,
    required this.isHollow,
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
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        side: isHollow
            ? MaterialStateProperty.all<BorderSide>(
                const BorderSide(
                  color: kAutismBridgeBlue,
                ),
              )
            : null,
      ),
      onPressed: onPressed,
    );
  }
}
