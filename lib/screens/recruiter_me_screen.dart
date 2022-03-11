import 'package:autism_bridge/color_constants.dart';
import 'package:autism_bridge/constants.dart';
import 'package:autism_bridge/models/recruiter_company_info.dart';
import 'package:autism_bridge/models/recruiter_profile.dart';
import 'package:autism_bridge/models/recruiter_user_credentials.dart';
import 'package:autism_bridge/screens/recruiter_company_info_screen.dart';
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

  Image? autismCareImage;

  Future<void> editMyProfileOnPressed() async {
    Utils.showProgressIndicator(context);
    try {
      RecruiterProfile? recruiterProfileTemp =
          await RecruiterProfile.readRecruiterProfileDataFromFirestore(
              widget.recruiterUserCredentials.userId);
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
      //widget.onValueChanged(widget.userResume);
      navigatorKey.currentState!.pop();
    } on FirebaseException catch (e) {
      navigatorKey.currentState!.pop();
      Utils.showSnackBar(
        e.message,
        kErrorIcon,
      );
      return;
    }
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
  void initState() {
    super.initState();
    autismCareImage = Image.asset('images/image_diff_btf.png');
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
            MyCardWidget(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(kResumeBuilderCardRadius),
                child: FittedBox(
                  child: autismCareImage,
                  fit: BoxFit.fill,
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
                      padding: EdgeInsets.only(left: 0.5.h),
                      child: GestureDetector(
                        onTap: companyInfoBtnOnPressed,
                        child: ListTile(
                          title: Row(
                            children: [
                              Image.asset(
                                'images/icon_career.png',
                                scale: 1.8,
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
