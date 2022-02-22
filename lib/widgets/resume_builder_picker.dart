import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ResumeBuilderPicker extends StatelessWidget {
  final Function() onPressed;
  final String title;
  final Text bodyText;
  final bool disableBorder;
  const ResumeBuilderPicker({
    Key? key,
    required this.onPressed,
    required this.title,
    required this.bodyText,
    required this.disableBorder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 1.85.h),
          child: Text(
            title,
            style: TextStyle(
              color: const Color(0xFF858597),
              fontSize: 10.sp,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 1.85.h,
          ),
          // child: SizedBox(
          //   height: 5.h,
          //   child: TextButton(
          //     onPressed: onPressed,
          //     child: Align(
          //       alignment: Alignment.centerLeft,
          //       child: bodyText,
          //     ),
          //     style: ButtonStyle(
          //       // padding: MaterialStateProperty.all<EdgeInsets>(
          //       //   EdgeInsets.all(1.5.h),
          //       // ),
          //       backgroundColor: MaterialStateProperty.all<Color>(
          //         Colors.red,
          //       ),
          //       // shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          //       //   RoundedRectangleBorder(
          //       //     borderRadius:
          //       //         BorderRadius.circular(kResumeBuilderCardRadius),
          //       //   ),
          //       // ),
          //       overlayColor: MaterialStateColor.resolveWith(
          //           (states) => Colors.transparent),
          //     ),
          //   ),
          // ),
          child: GestureDetector(
            onTap: onPressed,
            child: Container(
                height: 5.2.h,
                padding: EdgeInsets.symmetric(vertical: 1.3.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      width: 1.0,
                      color: disableBorder
                          ? Colors.white
                          : const Color(0xFFF0F0F2),
                    ),
                  ),
                ),
                child: bodyText),
          ),
        ),
      ],
    );
  }
}
