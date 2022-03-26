import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../color_constants.dart';

class MeSavedWidgets extends StatelessWidget {
  final String totalNumber;
  final String sectionName;
  final Function()? onPressed;

  const MeSavedWidgets({
    Key? key,
    required this.totalNumber,
    required this.sectionName,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Text(
            totalNumber,
            style: TextStyle(
              fontSize: 12.5.sp,
              color: kTitleBlack,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            sectionName,
            style: TextStyle(
              fontSize: 7.5.sp,
              color: kDarkTextGrey,
            ),
          ),
        ],
      ),
    );
  }
}
