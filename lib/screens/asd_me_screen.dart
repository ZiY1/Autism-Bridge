import 'package:autism_bridge/color_constants.dart';
import 'package:autism_bridge/models/asd_user_credentials.dart';
import 'package:autism_bridge/models/autism_challenge_data.dart';
import 'package:autism_bridge/models/education_data.dart';
import 'package:autism_bridge/models/employment_history_data.dart';
import 'package:autism_bridge/models/job_preference_data.dart';
import 'package:autism_bridge/models/personal_details_data.dart';
import 'package:autism_bridge/models/professional_summary_data.dart';
import 'package:autism_bridge/models/resume_data.dart';
import 'package:autism_bridge/models/skill_data.dart';
import 'package:autism_bridge/regular_helpers.dart';
import 'package:autism_bridge/screen_transition_animation/screen_transition_animation.dart';
import 'package:autism_bridge/screens/text_field_input_screen.dart';
import 'package:autism_bridge/screens/welcome_screen.dart';
import 'package:autism_bridge/widgets/me_saved_widget.dart';
import 'package:autism_bridge/widgets/my_card_widget.dart';
import 'package:autism_bridge/widgets/my_gradient_container.dart';
import 'package:autism_bridge/widgets/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../icon_constants.dart';
import '../main.dart';
import '../num_constants.dart';
import 'asd_manage_job_preference_screen.dart';
import 'asd_personal_details_screen.dart';
import 'asd_resume_builder_screen.dart';

class AsdMeScreen extends StatefulWidget {
  static const id = 'asd_me_screen';

  final AsdUserCredentials asdUserCredentials;

  final Resume userResume;

  final Function(Resume) onResumeValueChanged;

  final Function(List<JobPreference?>) onJobPreferenceListValueChanged;

  const AsdMeScreen({
    Key? key,
    required this.asdUserCredentials,
    required this.userResume,
    required this.onResumeValueChanged,
    required this.onJobPreferenceListValueChanged,
  }) : super(key: key);

  @override
  _AsdMeScreenState createState() => _AsdMeScreenState();
}

class _AsdMeScreenState extends State<AsdMeScreen> {
  Resume? userResume;

  final _auth = FirebaseAuth.instance;

  Image? autismCareImage;

  Future<void> editMyProfileOnPressed() async {
    Utils.showProgressIndicator(context);

    try {
      PersonalDetails? userPersonalDetails =
          await PersonalDetails.readPersonalDetailsDataFromFirestore(
              widget.asdUserCredentials.userId);
      userResume!.setPersonalDetails = userPersonalDetails;

      navigatorKey.currentState!.pop();

      final PersonalDetails? updatedPersonalDetails = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AsdPersonalDetailsScreen(
            asdUserCredentials: widget.asdUserCredentials,
            userResume: userResume!,
            isFirstTimeIn: false,
          ),
        ),
      );

      // Return non-null means changes have made in AsdPersonalDetailsScreen
      // so update the userPersonalDetails to updatedPersonalDetails
      if (updatedPersonalDetails != null) {
        if (!mounted) return;
        setState(() {
          userResume!.setPersonalDetails = updatedPersonalDetails;
        });
      }

      widget.onResumeValueChanged(userResume!);
    } on FirebaseException catch (e) {
      navigatorKey.currentState!.pop();
      Utils.showSnackBar(
        e.message,
        kErrorIcon,
      );
      return;
    }
  }

  Future<void> resumeBuilderBtnOnPressed() async {
    Utils.showProgressIndicator(context);

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

    userResume!.setPersonalDetails = userPersonalDetails;
    userResume!.setProfessionalSummary = userProfessionalSummary;
    userResume!.setEmploymentHistoryList = userEmploymentHistoryList;
    userResume!.setEducationList = userEducationList;
    userResume!.setSkillList = userSkillList;
    userResume!.setAutismChallengeList = userAutismChallengeList;

    navigatorKey.currentState!.pop();

    Resume resumeTemp = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AsdResumeBuilderScreen(
          asdUserCredentials: widget.asdUserCredentials,
          userResume: userResume!,
        ),
      ),
    );

    if (!mounted) return;
    setState(() {
      userResume!.setPersonalDetails = resumeTemp.userPersonalDetails;
    });
    userResume!.setProfessionalSummary = resumeTemp.userProfessionalSummary;
    userResume!.setEmploymentHistoryList = resumeTemp.userEmploymentHistoryList;
    userResume!.setEducationList = resumeTemp.userEducationList;
    userResume!.setSkillList = resumeTemp.userSkillList;
    userResume!.setAutismChallengeList = resumeTemp.userAutismChallengeList;

    widget.onResumeValueChanged(userResume!);
  }

  Future<void> jobPreferenceBtnOnPressed() async {
    Utils.showProgressIndicator(context);

    // userJobPreferenceList fetched from firebase
    /// !!! dart object pass by reference
    List<JobPreference?> userJobPreferenceList =
        await JobPreference.readAllJobPreferenceDataFromFirestore(
            userId: widget.asdUserCredentials.userId);

    // copy the userJobPreferenceList
    List<JobPreference?> oldUserJobPreferenceList = [...userJobPreferenceList];

    navigatorKey.currentState!.pop();

    userJobPreferenceList = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AsdManageJobPreferenceScreen(
          asdUserCredentials: widget.asdUserCredentials,
          userJobPreferenceList: userJobPreferenceList,
        ),
      ),
    );

    // call the callback function only when the item of oldUserJobPreferenceList
    // is different from userJobPreferenceList
    if (!RegularHelpers.areListsEqual(
        userJobPreferenceList, oldUserJobPreferenceList)) {
      widget.onJobPreferenceListValueChanged(userJobPreferenceList);
    }
  }

  @override
  void initState() {
    super.initState();
    userResume = widget.userResume;
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
                        '${userResume!.userPersonalDetails!.firstName} ${userResume!.userPersonalDetails!.lastName}',
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
                        child: userResume!.userPersonalDetails == null
                            ? const Icon(
                                CupertinoIcons.person_alt,
                                color: Color(0xFFBEC4D5),
                                size: 40.0,
                              )
                            : FittedBox(
                                child: Image.file(userResume!
                                    .userPersonalDetails!.profileImage),
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
                children: [
                  MeSavedWidgets(
                    totalNumber: '0',
                    sectionName: '  Job Chats  ',
                    // TODO: change later, used for temp testing
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TextFieldInputScreen(
                            title: 'Testing',
                            hintText: 'Hint test',
                            keyBoardType: TextInputType.text,
                          ),
                        ),
                      );
                    },
                  ),
                  const MeSavedWidgets(
                    totalNumber: '0',
                    sectionName: 'Sent Resumes ',
                  ),
                  const MeSavedWidgets(
                    totalNumber: '0',
                    sectionName: 'My Interviews',
                  ),
                  const MeSavedWidgets(
                    totalNumber: '0',
                    sectionName: '  Saved Jobs ',
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 1.5.h,
            ),
            MyCardWidget(
              child: SizedBox(
                height: 27.h,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(kCardRadius),
                  child: FittedBox(
                    child: Image.asset('images/undraw_AR.png'),
                    fit: BoxFit.fitWidth,
                  ),
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
                    GestureDetector(
                      onTap: resumeBuilderBtnOnPressed,
                      child: ListTile(
                        title: Row(
                          children: [
                            Image.asset(
                              'images/icon_my_cv.png',
                              scale: 1.3,
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
                    GestureDetector(
                      onTap: jobPreferenceBtnOnPressed,
                      child: ListTile(
                        title: Row(
                          children: [
                            Image.asset(
                              'images/icon_job_seek.png',
                              scale: 1.35,
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
                    GestureDetector(
                      onTap: () {
                        _auth.signOut();
                        Navigator.of(context).pushAndRemoveUntil(
                            ScreenTransitionAnimation.createBackRoute(
                                destScreen: const WelcomeScreen()),
                            (route) => false);
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
