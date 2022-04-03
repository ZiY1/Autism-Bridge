import 'package:autism_bridge/icon_constants.dart';
import 'package:autism_bridge/color_constants.dart';
import 'package:autism_bridge/models/recruiter_company_info.dart';
import 'package:autism_bridge/models/recruiter_job_post.dart';
import 'package:autism_bridge/models/recruiter_profile.dart';
import 'package:autism_bridge/models/recruiter_user_credentials.dart';
import 'package:autism_bridge/screens/recruiter_company_info_screen.dart';
import 'package:autism_bridge/screens/recruiter_manage_post_job_screen.dart';
import 'package:autism_bridge/screens/recruiter_profile_screen.dart';
import 'package:autism_bridge/screens/welcome_screen.dart';
import 'package:autism_bridge/widgets/me_saved_widget.dart';
import 'package:autism_bridge/widgets/my_card_widget.dart';
import 'package:autism_bridge/widgets/my_gradient_container.dart';
import 'package:autism_bridge/widgets/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../main.dart';
import '../num_constants.dart';

class RecruiterMeScreen extends StatefulWidget {
  static const id = 'recruiter_me_screen';

  final RecruiterUserCredentials recruiterUserCredentials;

  final RecruiterProfile recruiterProfile;

  //final Function(RecruiterProfile) onValueChanged;

  const RecruiterMeScreen({
    Key? key,
    required this.recruiterUserCredentials,
    required this.recruiterProfile,
    //required this.onValueChanged,
  }) : super(key: key);

  @override
  _RecruiterMeScreenState createState() => _RecruiterMeScreenState();
}

class _RecruiterMeScreenState extends State<RecruiterMeScreen> {
  final _auth = FirebaseAuth.instance;

  Future<void> editMyProfileOnPressed() async {
    Utils.showProgressIndicator(context);
    try {
      RecruiterProfile? recruiterProfileTemp =
          await RecruiterProfile.readRecruiterProfileDataFromFirestore(
              widget.recruiterUserCredentials.userId);

      navigatorKey.currentState!.pop();

      recruiterProfileTemp = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecruiterProfileScreen(
            recruiterUserCredentials: widget.recruiterUserCredentials,
            recruiterProfile: recruiterProfileTemp!,
          ),
        ),
      );

      if (recruiterProfileTemp != null) {
        widget.recruiterProfile.setProfileImageUrl =
            recruiterProfileTemp.profileImageUrl;
        widget.recruiterProfile.setCompanyName =
            recruiterProfileTemp.companyName;
        widget.recruiterProfile.setJobTitle = recruiterProfileTemp.jobTitle;
        setState(() {
          widget.recruiterProfile.setProfileImage =
              recruiterProfileTemp!.profileImage;
          widget.recruiterProfile.setFirstName = recruiterProfileTemp.firstName;
          widget.recruiterProfile.setLastName = recruiterProfileTemp.lastName;
        });
      }
    } on FirebaseException catch (e) {
      navigatorKey.currentState!.pop();
      Utils.showSnackBar(
        e.message,
        kErrorIcon,
      );
      return;
    }
  }

  Future<void> jobPostingBtnOnPressed() async {
    Utils.showProgressIndicator(context);

    List<RecruiterJobPost?> recruiterJobPostList =
        await RecruiterJobPost.readAllMyJobPostFromFirestore(
      userId: widget.recruiterUserCredentials.userId,
    );

    navigatorKey.currentState!.pop();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecruiterManagePostJobScreen(
          recruiterUserCredentials: widget.recruiterUserCredentials,
          recruiterJobPostList: recruiterJobPostList,
        ),
      ),
    );
  }

  Future<void> companyInfoBtnOnPressed() async {
    Utils.showProgressIndicator(context);

    try {
      RecruiterCompanyInfo? recruiterCompanyInfoTemp =
          await RecruiterCompanyInfo.readRecruiterCompanyInfoFromFirestore(
              widget.recruiterUserCredentials.userId);

      navigatorKey.currentState!.pop();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecruiterCompanyInfoScreen(
            recruiterUserCredentials: widget.recruiterUserCredentials,
            recruiterCompanyInfo: recruiterCompanyInfoTemp!,
          ),
        ),
      );
    } on FirebaseException catch (e) {
      navigatorKey.currentState!.pop();
      Utils.showSnackBar(
        e.message,
        kErrorIcon,
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyGradientContainer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: 1.5.h,
            vertical: 0.5.h,
          ),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.5.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.recruiterProfile.firstName} ${widget.recruiterProfile.lastName}',
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: kTitleBlack,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 0.5.h,
                      ),
                      GestureDetector(
                        onTap: editMyProfileOnPressed,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.edit_rounded,
                              size: 20,
                            ),
                            SizedBox(
                              width: 1.5.w,
                            ),
                            Text(
                              'Edit My Profile',
                              style: TextStyle(
                                  fontSize: 10.sp, color: kTitleBlack),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  CircleAvatar(
                    radius: 32.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100.0), //or 15.0
                      child: Container(
                        height: double.infinity,
                        width: double.infinity,
                        color: kBackgroundRiceWhite,
                        child: FittedBox(
                          child: Image.file(
                            widget.recruiterProfile.profileImage!,
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.5.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  MeSavedWidgets(
                    totalNumber: '0',
                    sectionName: 'Applicant Chats',
                  ),
                  MeSavedWidgets(
                    totalNumber: '0',
                    sectionName: 'Received Resumes',
                  ),
                  MeSavedWidgets(
                    totalNumber: '0',
                    sectionName: 'Sent Interviews',
                  ),
                  MeSavedWidgets(
                    totalNumber: '0',
                    sectionName: 'Saved Applicants',
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 1.5.h,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(kCardRadius),
              child: const Image(
                image: AssetImage('images/welcome_vr_interview.png'),
              ),
            ),
            SizedBox(
              height: 1.5.h,
            ),
            MyCardWidget(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 0.5.h),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 0.5.h),
                      child: GestureDetector(
                        onTap: () {
                          jobPostingBtnOnPressed();
                        },
                        child: ListTile(
                          title: Row(
                            children: [
                              // Image.asset(
                              //   'images/icon_new_job.png',
                              //   scale: 1.35,
                              // ),
                              Image(
                                image: const AssetImage(
                                  'images/icon_new_job.png',
                                ),
                                width: 4.6.h,
                                height: 4.6.h,
                              ),
                              SizedBox(
                                width: 2.7.w,
                              ),
                              const Text(
                                'Job Posting',
                                style: TextStyle(color: kTitleBlack),
                              ),
                            ],
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: kRegistrationSubtitleGrey,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 0.5.h),
                      child: GestureDetector(
                        onTap: companyInfoBtnOnPressed,
                        child: ListTile(
                          title: Row(
                            children: [
                              // Image.asset(
                              //   'images/icon_company.png',
                              //   scale: 1.35,
                              // ),
                              Image(
                                image: const AssetImage(
                                  'images/icon_company.png',
                                ),
                                width: 4.6.h,
                                height: 4.6.h,
                              ),
                              SizedBox(
                                width: 2.7.w,
                              ),
                              const Text(
                                'Company Information',
                                style: TextStyle(color: kTitleBlack),
                              ),
                            ],
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: kRegistrationSubtitleGrey,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 1.5.h,
            ),
            MyCardWidget(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 0.5.h),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 0.4.h),
                      child: GestureDetector(
                        onTap: () {
                          _auth.signOut();
                          Navigator.pushNamedAndRemoveUntil(
                              context, WelcomeScreen.id, (route) => false);
                        },
                        child: ListTile(
                          title: Row(
                            children: [
                              const Icon(
                                Icons.exit_to_app_rounded,
                                color: Colors.red,
                                size: 38,
                              ),
                              SizedBox(
                                width: 2.5.w,
                              ),
                              const Text(
                                'Sign Out',
                                style: TextStyle(color: kTitleBlack),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
