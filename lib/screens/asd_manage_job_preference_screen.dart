import 'package:autism_bridge/widgets/my_card_widget.dart';
import 'package:autism_bridge/widgets/rounded_icon_container.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../constants.dart';

import 'asd_job_preference_screen.dart';

class AsdManageJobPreferenceScreen extends StatefulWidget {
  static const id = 'asd_manage_job_preference_screen';

  final String userFirstName;

  final String userLastName;

  final String userEmail;

  final String userId;

  //final PersonalDetails? userPersonalDetails;

  const AsdManageJobPreferenceScreen({
    Key? key,
    required this.userFirstName,
    required this.userLastName,
    required this.userEmail,
    required this.userId,
    //required this.userPersonalDetails,
  }) : super(key: key);

  @override
  State<AsdManageJobPreferenceScreen> createState() =>
      _AsdManageJobPreferenceScreenState();
}

class _AsdManageJobPreferenceScreenState
    extends State<AsdManageJobPreferenceScreen> {
  @override
  Widget build(BuildContext context) {
    final Widget seg = SizedBox(height: 1.h);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [
            0.01,
            0.25,
          ],
          colors: [
            Color(0xFFE7F0F9),
            //kAutismBridgeBlue,
            kBackgroundRiceWhite,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          // title: const Text(
          //   'Job Preference',
          //   style: TextStyle(
          //     color: kTitleBlack,
          //   ),
          // ),
          iconTheme: const IconThemeData(
            color: kTitleBlack,
          ),
          leading: RoundedIconContainer(
            childIcon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: kTitleBlack,
              size: 20,
            ),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
            margin: EdgeInsets.all(1.35.h),
          ),
          leadingWidth: 14.8.w,
        ),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: 1.h,
              vertical: 1.2.h,
            ),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 1.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Manage Job Preferences',
                          style: TextStyle(
                              color: kTitleBlack,
                              fontSize: 18.5.sp,
                              fontWeight: FontWeight.w600),
                        ),
                        // TODO: use rich text
                        Text(
                          '1/3',
                          style: TextStyle(
                            color: kTitleBlack,
                            fontSize: 10.5.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 1.h, right: 1.h, bottom: 1.h),
                    child: Text(
                      'Add more job preferences,  get more job opportunities',
                      style: TextStyle(
                        color: kRegistrationSubtitleGrey,
                        fontSize: 9.5.sp,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 0.8.h,
                  vertical: 0.9.h,
                ),
                child: MyCardWidget(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 1.5.h,
                      vertical: 1.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        seg,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '[New York] Software Engineer',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: kTitleBlack,
                                    fontSize: 11.5.sp,
                                  ),
                                ),
                                Text(
                                  '3k - 5.5k • Full Time',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: kRegistrationSubtitleGrey,
                                      fontSize: 9.sp),
                                ),
                              ],
                            ),
                            IconButton(
                              alignment: Alignment.centerRight,
                              onPressed: () {
                                //TODO:
                              },
                              icon: const Icon(
                                Icons.arrow_forward_ios,
                                color: kRegistrationSubtitleGrey,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          height: 2.h,
                          thickness: 0.95,
                          color: const Color(0xFFF0F0F2),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '[New York] Software Engineer',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: kTitleBlack,
                                    fontSize: 11.5.sp,
                                  ),
                                ),
                                Text(
                                  '3k - 5.5k • Full Time',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: kRegistrationSubtitleGrey,
                                      fontSize: 9.sp),
                                ),
                              ],
                            ),
                            IconButton(
                              alignment: Alignment.centerRight,
                              onPressed: () {
                                //TODO:
                              },
                              icon: const Icon(
                                Icons.arrow_forward_ios,
                                color: kRegistrationSubtitleGrey,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        seg,
                        TextButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Add Job Preference',
                                style: TextStyle(
                                  color: kAutismBridgeBlue,
                                  fontSize: 11.sp,
                                ),
                              ),
                            ],
                          ),
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.all(1.55.h),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    kResumeBuilderCardRadius),
                              ),
                            ),
                            side: MaterialStateProperty.all<BorderSide>(
                              const BorderSide(
                                color: kAutismBridgeBlue,
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AsdJobPreferenceScreen(
                                  userFirstName: widget.userFirstName,
                                  userLastName: widget.userLastName,
                                  userEmail: widget.userEmail,
                                  userId: widget.userId,
                                ),
                              ),
                            );
                          },
                        ),
                        seg,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
