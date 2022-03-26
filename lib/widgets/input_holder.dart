import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class InputHolder extends StatelessWidget {
  final Function() onPressed;
  final String title;
  final String? bodyText;
  final String hintText;
  //final Text bodyText;
  final bool disableBorder;
  const InputHolder({
    Key? key,
    required this.onPressed,
    required this.title,
    required this.bodyText,
    required this.hintText,
    required this.disableBorder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 1.85.h, bottom: 0.2.h),
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
              height: 5.25.h,
              padding: EdgeInsets.symmetric(vertical: 1.3.h),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    width: 1.0,
                    color:
                        disableBorder ? Colors.white : const Color(0xFFF0F0F2),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  bodyText == null
                      ? Text(
                          hintText,
                          style: TextStyle(
                            fontSize: 9.5.sp,
                            color: Colors.grey.shade400,
                          ),
                        )
                      : Text(
                          bodyText!,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: const Color(0xFF1F1F39),
                          ),
                        ),
                  // const Icon(
                  //   Icons.arrow_right_rounded,
                  //   //CupertinoIcons.arrowtriangle_right_fill,
                  //   color: Color(0xFF858597),
                  //   //size: 10,
                  //   //size: 20.0,
                  // ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
