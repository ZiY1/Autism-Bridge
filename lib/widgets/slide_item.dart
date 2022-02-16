import 'package:flutter/material.dart';

import 'package:autism_bridge/models/welcome_item.dart';
import 'package:sizer/sizer.dart';

import '../constants.dart';

class SlideItem extends StatelessWidget {
  final int index;
  const SlideItem({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      //mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 27.h,
          height: 27.h,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(slideList[index].imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          height: 2.1.h,
        ),
        SizedBox(
          width: 60.w,
          child: Text(
            slideList[index].title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: kTitleBlack,
            ),
          ),
        ),
        SizedBox(
          height: 2.1.h,
        ),
        SizedBox(
          width: 55.w,
          child: Text(
            slideList[index].description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: kWelcomeSubtitleGrey,
            ),
          ),
        ),
      ],
    );
  }
}
