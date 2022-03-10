import 'package:autism_bridge/widgets/my_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../constants.dart';

class AsdJobScreen extends StatefulWidget {
  static const id = 'asd_me_screen';

  const AsdJobScreen({Key? key}) : super(key: key);

  @override
  _AsdJobScreenState createState() => _AsdJobScreenState();
}

class _AsdJobScreenState extends State<AsdJobScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.only(
          left: 1.5.h,
          right: 1.5.h,
          top: 0.5.h,
          bottom: 2.5.h,
        ),
        children: [
          Padding(
            padding: EdgeInsets.only(top: 1.5.h),
            child: MyCardWidget(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(8.0), //or 15.0
                              child: Container(
                                height: 5.h,
                                width: 5.h,
                                color: kBackgroundRiceWhite,
                                child: FittedBox(
                                  child: Image.network(
                                      'https://blog.hubspot.com/hubfs/image8-2.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            Text(
                              'Google LLC',
                              style: TextStyle(
                                color: const Color(0xFF173147),
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            //TODO:
                          },
                          icon: const Icon(
                            Icons.save_outlined,
                            color: Color(0xFF39587F),
                            size: 25,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Text(
                      'Google Cloud\'s Autism Career Program',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w600,
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
                              Icons.location_on_outlined,
                              color: Color(0xFF173147),
                              size: 28,
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            SizedBox(
                              width: 40.w,
                              child: Text(
                                '417 Miami Street New York USA',
                                style: TextStyle(
                                  color: const Color(0xFF707070),
                                  fontSize: 8.sp,
                                ),
                                maxLines: 3,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time_outlined,
                              color: Color(0xFF475B6D),
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Text(
                              'Full Time',
                              style: TextStyle(
                                color: const Color(0xFF707070),
                                fontSize: 7.sp,
                              ),
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
          Padding(
            padding: EdgeInsets.only(top: 1.5.h),
            child: MyCardWidget(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(8.0), //or 15.0
                              child: Container(
                                height: 5.h,
                                width: 5.h,
                                color: kBackgroundRiceWhite,
                                child: FittedBox(
                                  child: Image.network(
                                      'https://blog.hubspot.com/hubfs/image8-2.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            Text(
                              'Google LLC',
                              style: TextStyle(
                                color: const Color(0xFF173147),
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            //TODO:
                          },
                          icon: const Icon(
                            Icons.save_outlined,
                            color: Color(0xFF39587F),
                            size: 25,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Text(
                      'Google Cloud\'s Autism Career Program',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w600,
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
                              Icons.location_on_outlined,
                              color: Color(0xFF173147),
                              size: 28,
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            SizedBox(
                              width: 40.w,
                              child: Text(
                                '417 Miami Street New York USA',
                                style: TextStyle(
                                  color: const Color(0xFF707070),
                                  fontSize: 8.sp,
                                ),
                                maxLines: 3,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time_outlined,
                              color: Color(0xFF475B6D),
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Text(
                              'Full Time',
                              style: TextStyle(
                                color: const Color(0xFF707070),
                                fontSize: 7.sp,
                              ),
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
          Padding(
            padding: EdgeInsets.only(top: 1.5.h),
            child: MyCardWidget(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(8.0), //or 15.0
                              child: Container(
                                height: 5.h,
                                width: 5.h,
                                color: kBackgroundRiceWhite,
                                child: FittedBox(
                                  child: Image.network(
                                      'https://blog.hubspot.com/hubfs/image8-2.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            Text(
                              'Google LLC',
                              style: TextStyle(
                                color: const Color(0xFF173147),
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            //TODO:
                          },
                          icon: const Icon(
                            Icons.save_outlined,
                            color: Color(0xFF39587F),
                            size: 25,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Text(
                      'Google Cloud\'s Autism Career Program',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w600,
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
                              Icons.location_on_outlined,
                              color: Color(0xFF173147),
                              size: 28,
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            SizedBox(
                              width: 40.w,
                              child: Text(
                                '417 Miami Street New York USA',
                                style: TextStyle(
                                  color: const Color(0xFF707070),
                                  fontSize: 8.sp,
                                ),
                                maxLines: 3,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time_outlined,
                              color: Color(0xFF475B6D),
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Text(
                              'Full Time',
                              style: TextStyle(
                                color: const Color(0xFF707070),
                                fontSize: 7.sp,
                              ),
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
          Padding(
            padding: EdgeInsets.only(top: 1.5.h),
            child: MyCardWidget(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(8.0), //or 15.0
                              child: Container(
                                height: 5.h,
                                width: 5.h,
                                color: kBackgroundRiceWhite,
                                child: FittedBox(
                                  child: Image.network(
                                      'https://blog.hubspot.com/hubfs/image8-2.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            Text(
                              'Google LLC',
                              style: TextStyle(
                                color: const Color(0xFF173147),
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            //TODO:
                          },
                          icon: const Icon(
                            Icons.save_outlined,
                            color: Color(0xFF39587F),
                            size: 25,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Text(
                      'Google Cloud\'s Autism Career Program',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w600,
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
                              Icons.location_on_outlined,
                              color: Color(0xFF173147),
                              size: 28,
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            SizedBox(
                              width: 40.w,
                              child: Text(
                                '417 Miami Street New York USA',
                                style: TextStyle(
                                  color: const Color(0xFF707070),
                                  fontSize: 8.sp,
                                ),
                                maxLines: 3,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time_outlined,
                              color: Color(0xFF475B6D),
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Text(
                              'Full Time',
                              style: TextStyle(
                                color: const Color(0xFF707070),
                                fontSize: 7.sp,
                              ),
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
        ],
      ),
    );
  }
}
