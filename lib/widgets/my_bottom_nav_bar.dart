import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MyBottomNavBar extends StatelessWidget {
  final Widget firstRow;
  final Widget secondRow;
  final Widget thirdRow;
  final Widget middleSearch;
  const MyBottomNavBar(
      {Key? key,
      required this.firstRow,
      required this.secondRow,
      required this.thirdRow,
      required this.middleSearch})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          child: Container(
            height: 12.h,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8A959E).withOpacity(0.2),
                  spreadRadius: 0,
                  blurRadius: 30.0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              child: BottomAppBar(
                elevation: 0,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 3.8.h, right: 4.12.h),
                      child: firstRow,
                    ),
                    SizedBox(
                      height: 1.7.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.8.h,
                      ),
                      child: secondRow,
                    ),
                    SizedBox(
                      height: 0.75.h,
                    ),
                    thirdRow,
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 42.7.w,
          bottom: 6.h,
          child: Container(
            width: 7.8.h,
            height: 7.8.h,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          left: 44.14.w,
          bottom: 6.65.h,
          child: middleSearch,
        ),
      ],
    );
  }
}
