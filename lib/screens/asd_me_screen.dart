import 'package:autism_bridge/constants.dart';
import 'package:autism_bridge/models/asd_user_credentials.dart';
import 'package:autism_bridge/models/autism_challenge_data.dart';
import 'package:autism_bridge/models/education_data.dart';
import 'package:autism_bridge/models/employment_history_data.dart';
import 'package:autism_bridge/models/job_preference_data.dart';
import 'package:autism_bridge/models/personal_details_data.dart';
import 'package:autism_bridge/models/professional_summary_data.dart';
import 'package:autism_bridge/models/resume_data.dart';
import 'package:autism_bridge/models/skill_data.dart';
import 'package:autism_bridge/screens/asd_home_screen.dart';
import 'package:autism_bridge/screens/welcome_screen.dart';
import 'package:autism_bridge/widgets/my_card_widget.dart';
import 'package:autism_bridge/widgets/my_gradient_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'asd_manage_job_preference_screen.dart';
import 'asd_resume_builder_screen.dart';

class AsdMeScreen extends StatefulWidget {
  static const id = 'asd_me_screen';

  final AsdUserCredentials asdUserCredentials;

  final Resume userResume;

  final Function(Resume) onValueChanged;

  const AsdMeScreen({
    Key? key,
    required this.asdUserCredentials,
    required this.userResume,
    required this.onValueChanged,
  }) : super(key: key);

  @override
  _AsdMeScreenState createState() => _AsdMeScreenState();
}

class _AsdMeScreenState extends State<AsdMeScreen> {
  final _auth = FirebaseAuth.instance;

  Future<void> resumeBuilderBtnOnPressed() async {
    PersonalDetails? userPersonalDetails =
        await PersonalDetails.readPersonalDetailsDataFromFirestore(
            widget.asdUserCredentials.userId);

    ProfessionalSummary? userProfessionalSummary =
        await ProfessionalSummary.readProfessionalSummaryDataFromFirestore(
            widget.asdUserCredentials.userId);

    // try to read cv_employment_history of current users' subcollection employment_histories in firestore
    // Store it/them in List<EmploymentHistory?> userEmploymentHistory
    // Two Cases:
    // 1. has no data, so userEmploymentHistory has a list of null
    // 2. has data, so userEmploymentHistory has a list of EmploymentHistory obj

    List<EmploymentHistory?> userEmploymentHistoryList =
        await EmploymentHistory.readAllEmploymentHistoryDataFromFirestore(
            userId: widget.asdUserCredentials.userId);

    List<Education?> userEducationList =
        await Education.readAllEducationDataFromFirestore(
            userId: widget.asdUserCredentials.userId);

    List<Skill?> userSkillList = await Skill.readAllSkillDataFromFirestore(
        userId: widget.asdUserCredentials.userId);

    List<AutismChallenge?> userAutismChallengeList =
        await AutismChallenge.readAllAutismChallengeDataFromFirestore(
            userId: widget.asdUserCredentials.userId);

    widget.userResume.setPersonalDetails = userPersonalDetails;
    widget.userResume.setProfessionalSummary = userProfessionalSummary;
    widget.userResume.setEmploymentHistoryList = userEmploymentHistoryList;
    widget.userResume.setEducationList = userEducationList;
    widget.userResume.setSkillList = userSkillList;
    widget.userResume.setAutismChallengeList = userAutismChallengeList;

    Resume resumeTemp = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AsdResumeBuilderScreen(
          asdUserCredentials: widget.asdUserCredentials,
          userResume: widget.userResume,
        ),
      ),
    );

    setState(() {
      widget.userResume.setPersonalDetails = resumeTemp.userPersonalDetails;
      widget.userResume.setProfessionalSummary =
          resumeTemp.userProfessionalSummary;
      widget.userResume.setEmploymentHistoryList =
          resumeTemp.userEmploymentHistoryList;
      widget.userResume.setEducationList = resumeTemp.userEducationList;
      widget.userResume.setSkillList = resumeTemp.userSkillList;
      widget.userResume.setAutismChallengeList =
          resumeTemp.userAutismChallengeList;
    });

    widget.onValueChanged(widget.userResume);
  }

  Future<void> jobPreferenceBtnOnPressed() async {
    List<JobPreference?> userJobPreferenceList =
        await JobPreference.readAllJobPreferenceDataFromFirestore(
            userId: widget.asdUserCredentials.userId);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AsdManageJobPreferenceScreen(
          asdUserCredentials: widget.asdUserCredentials,
          userJobPreferenceList: userJobPreferenceList,
        ),
      ),
    );
  }

  Widget buildBody() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(1.5.h),
        child: Column(
          children: [
            MyCardWidget(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 0.5.h),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        resumeBuilderBtnOnPressed();
                      },
                      child: ListTile(
                        title: Row(
                          children: [
                            Image.asset(
                              'images/icon_resume.png',
                              scale: 1.5,
                            ),
                            SizedBox(
                              width: 2.5.w,
                            ),
                            const Text(
                              'Resume Builder',
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
                    Padding(
                      padding: EdgeInsets.only(left: 0.5.h),
                      child: GestureDetector(
                        onTap: () {
                          jobPreferenceBtnOnPressed();
                        },
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
                                'Job Preferences',
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
            // Text(widget.asdUserCredentials.userEmail),
            // Text(widget.asdUserCredentials.userId),
            // Text(
            //     '${widget.asdUserCredentials.userFirstName} ${widget.asdUserCredentials.userLastName}'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // return CustomScrollView(
    //   slivers: [
    //     SliverAppBar(
    //       backgroundColor: kAutismBridgeBlue,
    //       expandedHeight: 15.h,
    //       flexibleSpace: FlexibleSpaceBar(
    //         title: Padding(
    //           padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.h),
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             children: [
    //               Text(
    //                 '${widget.asdUserCredentials.userFirstName} ${widget.asdUserCredentials.userLastName}',
    //                 style: TextStyle(fontSize: 15.sp),
    //               ),
    //               ClipRRect(
    //                 borderRadius: BorderRadius.circular(5.0), //or 15.0
    //                 child: Container(
    //                   height: 5.5.h,
    //                   width: 5.5.h,
    //                   color: kBackgroundRiceWhite,
    //                   child: const Icon(
    //                     CupertinoIcons.person_alt,
    //                     color: Color(0xFFBEC4D5),
    //                     size: 30.0,
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //     buildBody(),
    //   ],
    // );
    return MyGradientContainer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: 1.5.h,
            vertical: 0.5.h,
          ),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      '${widget.userResume.userPersonalDetails!.firstName} ${widget.userResume.userPersonalDetails!.lastName}',
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: kTitleBlack,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5.0), //or 15.0
                  child: Container(
                    height: 5.5.h,
                    width: 5.5.h,
                    color: kBackgroundRiceWhite,
                    child: const Icon(
                      CupertinoIcons.person_alt,
                      color: Color(0xFFBEC4D5),
                      size: 30.0,
                    ),
                  ),
                ),
              ],
            ),
            MyCardWidget(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 0.5.h),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        resumeBuilderBtnOnPressed();
                      },
                      child: ListTile(
                        title: Row(
                          children: [
                            Image.asset(
                              'images/icon_resume.png',
                              scale: 1.5,
                            ),
                            SizedBox(
                              width: 2.5.w,
                            ),
                            const Text(
                              'Resume Builder',
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
                    Padding(
                      padding: EdgeInsets.only(left: 0.5.h),
                      child: GestureDetector(
                        onTap: () {
                          jobPreferenceBtnOnPressed();
                        },
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
                                'Job Preferences',
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
