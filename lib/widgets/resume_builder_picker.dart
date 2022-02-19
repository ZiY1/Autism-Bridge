import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ResumeBuilderPicker extends StatelessWidget {
  final Function() onPressed;
  final String title;
  final Text bodyText;
  final double? bottomPadding;
  const ResumeBuilderPicker(
      {Key? key,
      required this.onPressed,
      required this.title,
      required this.bodyText,
      this.bottomPadding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 1.65.h, bottom: 0.3.h),
          child: Text(
            title,
            style: TextStyle(
              color: const Color(0xFF858597),
              fontSize: 10.sp,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 1.5.h,
            right: 1.5.h,
            bottom: bottomPadding == null ? 1.5.h : bottomPadding!.h,
          ),
          child: SizedBox(
            height: 5.8.h,
            child: TextButton(
              onPressed: onPressed,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 0.5.h),
                  child: bodyText,
                ),
              ),
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                  EdgeInsets.all(1.5.h),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.white,
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                overlayColor: MaterialStateColor.resolveWith(
                    (states) => Colors.transparent),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
