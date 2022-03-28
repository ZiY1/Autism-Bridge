import 'package:autism_bridge/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RegistrationTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function()? backOnPressed;

  const RegistrationTitle({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.backOnPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 1.5.h, top: 3.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: kTitleBlack,
                  fontSize: 23.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 0.7.h, right: 0.3.h),
                child: backOnPressed == null
                    ? null
                    : IconButton(
                        onPressed: backOnPressed,
                        icon: const Icon(
                          Icons.close,
                          color: Color(0xFF858597),
                          size: 30.0,
                        ),
                      ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 1.5.h, bottom: 1.5.h),
          child: Text(
            subtitle,
            style: TextStyle(
              color: kRegistrationSubtitleGrey,
              fontSize: 9.sp,
            ),
          ),
        ),
      ],
    );
  }
}
