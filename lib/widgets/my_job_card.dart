import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'dart:io';
import '../constants.dart';
import 'my_card_widget.dart';

class MyJobCard extends StatelessWidget {
  final File companyLogo;
  final String companyName;
  final String jobName;
  final String jobCity;
  final String jobState;
  final String employmentType;
  final Function()? jobOnPressed;
  final Function()? bookmarkOnPressed;
  const MyJobCard({
    Key? key,
    required this.companyLogo,
    required this.companyName,
    required this.jobName,
    required this.jobCity,
    required this.jobState,
    required this.employmentType,
    required this.jobOnPressed,
    required this.bookmarkOnPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: jobOnPressed,
      behavior: HitTestBehavior.translucent,
      child: Padding(
        padding: EdgeInsets.only(top: 1.5.h),
        child: MyCardWidget(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.0), //or 15.0
                          child: Container(
                            height: 5.h,
                            width: 5.h,
                            color: kBackgroundRiceWhite,
                            child: FittedBox(
                              child: Image.file(companyLogo),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        Text(
                          companyName,
                          style: TextStyle(
                            color: const Color(0xFF173147),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: bookmarkOnPressed,
                      child: const Icon(
                        CupertinoIcons.bookmark,
                        color: Color(0xFF39587F),
                        size: 25,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 3.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 0.3.h),
                  child: Text(
                    jobName,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.location,
                          color: Color(0xFF475B6D),
                          size: 28,
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        SizedBox(
                          width: 30.w,
                          child: Text(
                            '$jobCity, $jobState',
                            style: TextStyle(
                              color: const Color(0xFF707070),
                              fontSize: 7.sp,
                            ),
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.clock,
                          color: Color(0xFF475B6D),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          employmentType,
                          style: TextStyle(
                            color: const Color(0xFF707070),
                            fontSize: 7.sp,
                          ),
                        ),
                        SizedBox(
                          width: 2.2.w,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
