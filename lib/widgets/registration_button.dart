import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../constants.dart';

class RegistrationButton extends StatelessWidget {
  final Icon? icon;
  final Function()? onPressed;
  final Widget child;

  const RegistrationButton({
    Key? key,
    this.icon,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Icon(icon),
          Container(
            padding: icon == null ? null : EdgeInsets.only(right: 1.5.h),
            child: icon,
          ),
          child,
        ],
      ),
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.all(1.55.h),
        ),
        backgroundColor: onPressed == null
            ? MaterialStateProperty.all<Color>(
                kAutismBridgeBlue.withOpacity(0.45),
              )
            : MaterialStateProperty.all<Color>(
                kAutismBridgeBlue,
              ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
