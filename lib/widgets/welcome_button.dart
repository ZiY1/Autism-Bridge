import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class WelcomeButton extends StatelessWidget {
  final String btnName;
  final Function() onPressed;
  final bool isHollow;

  const WelcomeButton({
    Key? key,
    required this.btnName,
    required this.onPressed,
    required this.isHollow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 43.w,
      height: 6.7.h,
      child: TextButton(
          child: Text(
            btnName,
            style: TextStyle(
              fontSize: 13.sp,
              color: isHollow ? const Color(0xFF2A6BAC) : Colors.white,
            ),
          ),
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
              EdgeInsets.all(1.5.h),
            ),
            backgroundColor: isHollow
                ? null
                : MaterialStateProperty.all<Color>(
                    const Color(0xFF2A6BAC),
                  ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            side: isHollow
                ? MaterialStateProperty.all<BorderSide>(
                    const BorderSide(
                      color: Color(0xFF2A6BAC),
                    ),
                  )
                : null,
          ),
          onPressed: onPressed),
    );
  }
}
