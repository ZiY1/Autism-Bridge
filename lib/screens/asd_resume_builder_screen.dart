import 'package:autism_bridge/apis/pdf_api.dart';
import 'package:autism_bridge/apis/resume_pdf_api.dart';
import 'package:autism_bridge/models/autism_challenge_data.dart';
import 'package:autism_bridge/models/education_data.dart';
import 'package:autism_bridge/models/employment_history_data.dart';
import 'package:autism_bridge/models/personal_details_data.dart';
import 'package:autism_bridge/models/professional_summary_data.dart';
import 'package:autism_bridge/models/resume_data.dart';
import 'package:autism_bridge/models/skill_data.dart';
import 'package:autism_bridge/screens/asd_autism_challenges_screen.dart';
import 'package:autism_bridge/screens/asd_education_screen.dart';
import 'package:autism_bridge/screens/asd_employment_history_screen.dart';
import 'package:autism_bridge/screens/asd_pdf_viewer_screen.dart';
import 'package:autism_bridge/screens/asd_personal_details_screen.dart';
import 'package:autism_bridge/screens/asd_professional_summary_screen.dart';
import 'package:autism_bridge/screens/asd_skills_screen.dart';
import 'package:autism_bridge/widgets/my_card_widget.dart';
import 'package:autism_bridge/widgets/resume_builder_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../constants.dart';

class AsdResumeBuilderScreen extends StatefulWidget {
  static const id = 'asd_resume_builder_screen';

  final String userFirstName;

  final String userLastName;

  final String userEmail;

  final String userId;

  final PersonalDetails? userPersonalDetails;

  final ProfessionalSummary? userProfessionalSummary;

  final List<EmploymentHistory?> userEmploymentHistoryList;

  final List<Education?> userEducationList;

  final List<Skill?> userSkillList;

  final List<AutismChallenge?> userAutismChallengeList;

  const AsdResumeBuilderScreen({
    Key? key,
    required this.userFirstName,
    required this.userLastName,
    required this.userEmail,
    required this.userId,
    required this.userPersonalDetails,
    required this.userProfessionalSummary,
    required this.userEmploymentHistoryList,
    required this.userEducationList,
    required this.userSkillList,
    required this.userAutismChallengeList,
  }) : super(key: key);

  @override
  _AsdResumeBuilderScreenState createState() => _AsdResumeBuilderScreenState();
}

class _AsdResumeBuilderScreenState extends State<AsdResumeBuilderScreen> {
  double profileCompleteness = 0.0;

  bool isPersonalDetailsComplete = false;

  PersonalDetails? userPersonalDetails;

  bool isProfessionalSummaryComplete = false;

  ProfessionalSummary? userProfessionalSummary;

  bool isEmploymentHistoryComplete = false;

  List<EmploymentHistory?>? userEmploymentHistoryList;

  bool isEducationComplete = false;

  List<Education?>? userEducationList;

  bool isSkillComplete = false;

  List<Skill?>? userSkillList;

  bool isAutismChallengeComplete = false;

  List<AutismChallenge?>? userAutismChallengeList;

  @override
  void initState() {
    super.initState();

    userPersonalDetails = widget.userPersonalDetails;
    if (userPersonalDetails != null) {
      profileCompleteness += 1 / 6;
      isPersonalDetailsComplete = true;
    }

    userProfessionalSummary = widget.userProfessionalSummary;
    if (userProfessionalSummary != null) {
      profileCompleteness += 1 / 6;
      isProfessionalSummaryComplete = true;
    }

    userEmploymentHistoryList = widget.userEmploymentHistoryList;
    if (userEmploymentHistoryList != null &&
        userEmploymentHistoryList!.isNotEmpty) {
      profileCompleteness += 1 / 6;
      isEmploymentHistoryComplete = true;
    }

    userEducationList = widget.userEducationList;
    if (userEducationList != null && userEducationList!.isNotEmpty) {
      profileCompleteness += 1 / 6;
      isEducationComplete = true;
    }

    userSkillList = widget.userSkillList;
    if (userSkillList != null && userSkillList!.isNotEmpty) {
      profileCompleteness += 1 / 6;
      isSkillComplete = true;
    }

    userAutismChallengeList = widget.userAutismChallengeList;
    if (userAutismChallengeList != null &&
        userAutismChallengeList!.isNotEmpty) {
      profileCompleteness += 1 / 6;
      isAutismChallengeComplete = true;
    }
  }

  Future<void> autismChallengeAddBtnOnPressed(BuildContext context) async {
    final List<AutismChallenge?>? updatedAutismChallengeList =
        await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AsdAutismChallengesScreen(
          userId: widget.userId,
          userEmail: widget.userEmail,
          userFirstName: widget.userFirstName,
          userLastName: widget.userLastName,
          isAddingNew: true,
          userAutismChallengeList: userAutismChallengeList!,
        ),
      ),
    );

    if (updatedAutismChallengeList != null) {
      setState(() {
        userAutismChallengeList = updatedAutismChallengeList;
      });
      if (!isAutismChallengeComplete) {
        isAutismChallengeComplete = true;
        setState(() {
          profileCompleteness += 1 / 6;
        });
      }
    }
  }

  Future<void> skillUpdateBtnOnPressed(
      {required BuildContext context,
      required String subCollectionId,
      required int listIndex}) async {
    final List<Skill?>? updatedSkillList = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AsdSkillsScreen(
          userId: widget.userId,
          userEmail: widget.userEmail,
          userFirstName: widget.userFirstName,
          userLastName: widget.userLastName,
          isAddingNew: false,
          subCollectionId: subCollectionId,
          listIndex: listIndex,
          userSkillList: userSkillList!,
        ),
      ),
    );

    if (updatedSkillList != null) {
      setState(() {
        userSkillList = updatedSkillList;
      });
      if (updatedSkillList.isEmpty) {
        setState(() {
          isSkillComplete = false;
          profileCompleteness -= 1 / 6;
        });
      }
    }
  }

  Future<void> autismChallengeUpdateBtnOnPressed(
      {required BuildContext context,
      required String subCollectionId,
      required int listIndex}) async {
    final List<AutismChallenge?>? updatedAutismChallengeList =
        await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AsdAutismChallengesScreen(
          userId: widget.userId,
          userEmail: widget.userEmail,
          userFirstName: widget.userFirstName,
          userLastName: widget.userLastName,
          isAddingNew: false,
          subCollectionId: subCollectionId,
          listIndex: listIndex,
          userAutismChallengeList: userAutismChallengeList!,
        ),
      ),
    );

    if (updatedAutismChallengeList != null) {
      setState(() {
        userAutismChallengeList = updatedAutismChallengeList;
      });
      if (updatedAutismChallengeList.isEmpty) {
        setState(() {
          isAutismChallengeComplete = false;
          profileCompleteness -= 1 / 6;
        });
      }
    }
  }

  Future<void> skillAddBtnOnPressed(BuildContext context) async {
    final List<Skill?>? updatedSkillList = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AsdSkillsScreen(
          userId: widget.userId,
          userEmail: widget.userEmail,
          userFirstName: widget.userFirstName,
          userLastName: widget.userLastName,
          isAddingNew: true,
          userSkillList: userSkillList!,
        ),
      ),
    );

    if (updatedSkillList != null) {
      setState(() {
        userSkillList = updatedSkillList;
      });
      if (!isSkillComplete) {
        isSkillComplete = true;
        setState(() {
          profileCompleteness += 1 / 6;
        });
      }
    }
  }

  Future<void> educationUpdateBtnOnPressed(
      {required BuildContext context,
      required String subCollectionId,
      required int listIndex}) async {
    final List<Education?>? updatedEducationList = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AsdEducationScreen(
          userId: widget.userId,
          userEmail: widget.userEmail,
          userFirstName: widget.userFirstName,
          userLastName: widget.userLastName,
          isAddingNew: false,
          subCollectionId: subCollectionId,
          listIndex: listIndex,
          userEducationList: userEducationList!,
        ),
      ),
    );

    if (updatedEducationList != null) {
      setState(() {
        userEducationList = updatedEducationList;
      });
      if (updatedEducationList.isEmpty) {
        setState(() {
          isEducationComplete = false;
          profileCompleteness -= 1 / 6;
        });
      }
    }
  }

  Future<void> educationAddBtnOnPressed(BuildContext context) async {
    final List<Education?>? updatedEducationList = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AsdEducationScreen(
          userId: widget.userId,
          userEmail: widget.userEmail,
          userFirstName: widget.userFirstName,
          userLastName: widget.userLastName,
          isAddingNew: true,
          userEducationList: userEducationList!,
        ),
      ),
    );

    if (updatedEducationList != null) {
      setState(() {
        userEducationList = updatedEducationList;
      });
      if (!isEducationComplete) {
        isEducationComplete = true;
        setState(() {
          profileCompleteness += 1 / 6;
        });
      }
    }
  }

  Future<void> employmentHistoryUpdateBtnOnPressed(
      {required BuildContext context,
      required String subCollectionId,
      required int listIndex}) async {
    final List<EmploymentHistory?>? updatedEmploymentHistoryList =
        await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AsdEmploymentHistoryScreen(
          userId: widget.userId,
          userEmail: widget.userEmail,
          userFirstName: widget.userFirstName,
          userLastName: widget.userLastName,
          isAddingNew: false,
          subCollectionId: subCollectionId,
          listIndex: listIndex,
          userEmploymentHistoryList: userEmploymentHistoryList!,
        ),
      ),
    );

    if (updatedEmploymentHistoryList != null) {
      setState(() {
        userEmploymentHistoryList = updatedEmploymentHistoryList;
      });
      if (updatedEmploymentHistoryList.isEmpty) {
        setState(() {
          isEmploymentHistoryComplete = false;
          profileCompleteness -= 1 / 6;
        });
      }
    }
  }

  Future<void> employmentHistoryAddBtnOnPressed(BuildContext context) async {
    final List<EmploymentHistory?>? updatedEmploymentHistoryList =
        await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AsdEmploymentHistoryScreen(
          userId: widget.userId,
          userEmail: widget.userEmail,
          userFirstName: widget.userFirstName,
          userLastName: widget.userLastName,
          isAddingNew: true,
          userEmploymentHistoryList: userEmploymentHistoryList!,
        ),
      ),
    );

    if (updatedEmploymentHistoryList != null) {
      setState(() {
        userEmploymentHistoryList = updatedEmploymentHistoryList;
      });
      if (!isEmploymentHistoryComplete) {
        isEmploymentHistoryComplete = true;
        setState(() {
          profileCompleteness += 1 / 6;
        });
      }
    }
  }

  Future<void> personalDetailsBtnOnPressed(BuildContext context) async {
    final PersonalDetails? updatedPersonalDetails = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AsdPersonalDetailsScreen(
          userFirstName: widget.userFirstName,
          userLastName: widget.userLastName,
          userEmail: widget.userEmail,
          userId: widget.userId,
          userPersonalDetails: userPersonalDetails,
        ),
      ),
    );

    // Return non-null means changes have made in AsdPersonalDetailsScreen
    // so update the userPersonalDetails to updatedPersonalDetails
    if (updatedPersonalDetails != null) {
      setState(() {
        userPersonalDetails = updatedPersonalDetails;
      });
      if (!isPersonalDetailsComplete) {
        isPersonalDetailsComplete = true;
        setState(() {
          profileCompleteness += 1 / 6;
        });
      }
    }
  }

  Future<void> professionalSummaryBtnOnPressed(BuildContext context) async {
    final ProfessionalSummary? updatedProfessionalSummary =
        await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AsdProfessionalSummaryScreen(
          userFirstName: widget.userFirstName,
          userLastName: widget.userLastName,
          userEmail: widget.userEmail,
          userId: widget.userId,
          userProfessionalSummary: userProfessionalSummary,
        ),
      ),
    );

    // Return non-null means changes have made in AsdPersonalDetailsScreen
    // so update the userPersonalDetails to updatedPersonalDetails
    if (updatedProfessionalSummary != null) {
      setState(() {
        userProfessionalSummary = updatedProfessionalSummary;
      });
      if (!isProfessionalSummaryComplete) {
        isProfessionalSummaryComplete = true;
        setState(() {
          profileCompleteness += 1 / 6;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundRiceWhite,
      appBar: AppBar(
        elevation: 0.0,
        // backgroundColor: kBackgroundRiceWhite,
        backgroundColor: kAutismBridgeBlue,
        title: const Text(
          'Resume Builder',
          // style: TextStyle(
          //   fontWeight: FontWeight.w900,
          //   letterSpacing: 0.6,
          // ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: 1.5.h,
            vertical: 0.5.h,
          ),
          children: [
            Padding(
                padding: EdgeInsets.only(left: 1.h, top: 2.h),
                child: Row(
                  children: [
                    Text(
                      '${double.parse((profileCompleteness * 100).toStringAsFixed(1))} % ',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: kAutismBridgeBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      ' Profile Completeness',
                      style: TextStyle(
                        fontSize: 9.5.sp,
                        color: const Color(0xFF808080),
                      ),
                    ),
                  ],
                )),
            Padding(
              padding: EdgeInsets.only(bottom: 1.5.h),
              child: LinearPercentIndicator(
                //backgroundColor: const Color(0xFFEFF2F9),
                //width: MediaQuery.of(context).size.width - 40,
                animation: true,
                lineHeight: 1.h,
                animationDuration: 900,
                percent: profileCompleteness,
                //center: Text("80.0%"),
                barRadius: const Radius.circular(5.0),
                progressColor: kAutismBridgeBlue,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 0.8.h,
                vertical: 1.h,
              ),
              child: MyCardWidget(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 1.2.h,
                    vertical: 1.5.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                userPersonalDetails == null
                                    ? 'Personal Details'
                                    : '${userPersonalDetails!.firstName} ${userPersonalDetails!.lastName}',
                                style: TextStyle(
                                  color: kTitleBlack,
                                  fontSize: 15.sp,
                                ),
                              ),
                              SizedBox(
                                width: 1.w,
                              ),
                              IconButton(
                                onPressed: () {
                                  personalDetailsBtnOnPressed(context);
                                },
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: kTitleBlack,
                                  size: 23.5,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            userPersonalDetails == null
                                ? 'Wanted Job Title • City'
                                : '${userPersonalDetails!.wantedJobTitle} • ${userPersonalDetails!.city}',
                            style: TextStyle(
                                color: kRegistrationSubtitleGrey,
                                fontSize: 10.sp),
                          ),
                        ],
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5.0), //or 15.0
                        child: Container(
                          height: 9.h,
                          width: 9.h,
                          color: kBackgroundRiceWhite,
                          child: userPersonalDetails == null
                              ? const Icon(
                                  CupertinoIcons.person_alt,
                                  color: Color(0xFFBEC4D5),
                                  size: 40.0,
                                )
                              : FittedBox(
                                  child: Image.file(
                                      userPersonalDetails!.profileImage),
                                  fit: BoxFit.fill,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 0.8.h,
                vertical: 1.h,
              ),
              child: MyCardWidget(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 1.2.h,
                    right: 1.2.h,
                    bottom: 1.5.h,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Professional Summary',
                            style: TextStyle(
                              color: kTitleBlack,
                              fontSize: 14.sp,
                            ),
                          ),
                          IconButton(
                            alignment: Alignment.centerRight,
                            onPressed: () {
                              professionalSummaryBtnOnPressed(context);
                            },
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: kTitleBlack,
                              size: 22.5,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          userProfessionalSummary == null
                              ? 'Add your professional summary...'
                              : userProfessionalSummary!.summaryText,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: kRegistrationSubtitleGrey,
                              fontSize: 10.sp),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 0.8.h,
                vertical: 1.h,
              ),
              child: MyCardWidget(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 1.2.h,
                    right: 1.2.h,
                    bottom: 1.5.h,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Employment History',
                            style: TextStyle(
                              color: kTitleBlack,
                              fontSize: 14.sp,
                            ),
                          ),
                          IconButton(
                            alignment: Alignment.centerRight,
                            onPressed: () {
                              employmentHistoryAddBtnOnPressed(context);
                            },
                            icon: const Icon(
                              Icons.add_circle_outline,
                              color: kTitleBlack,
                              size: 22.5,
                            ),
                          ),
                        ],
                      ),
                      userEmploymentHistoryList!.isNotEmpty
                          ? ListView.builder(
                              itemBuilder: (context, index) {
                                final EmploymentHistory?
                                    currentEmploymentHistory =
                                    userEmploymentHistoryList![index];
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            currentEmploymentHistory!.employer,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: kTitleBlack,
                                              fontSize: 11.5.sp,
                                            ),
                                          ),
                                          Text(
                                            '${currentEmploymentHistory.jobTitle} • ${currentEmploymentHistory.startDate} - ${currentEmploymentHistory.endDate}',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                                color:
                                                    kRegistrationSubtitleGrey,
                                                fontSize: 9.5.sp),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      alignment: Alignment.centerRight,
                                      onPressed: () {
                                        employmentHistoryUpdateBtnOnPressed(
                                          context: context,
                                          subCollectionId:
                                              currentEmploymentHistory
                                                  .subCollectionId,
                                          listIndex: index,
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.arrow_forward_ios,
                                        color: kRegistrationSubtitleGrey,
                                        size: 23.5,
                                      ),
                                    ),
                                  ],
                                );
                              },
                              itemCount: userEmploymentHistoryList!.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                            )
                          : Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Create your first employment history . . .',
                                style: TextStyle(
                                    color: kRegistrationSubtitleGrey,
                                    fontSize: 9.5.sp),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 0.8.h,
                vertical: 1.h,
              ),
              child: MyCardWidget(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 1.2.h,
                    right: 1.2.h,
                    bottom: 1.5.h,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Education',
                            style: TextStyle(
                              color: kTitleBlack,
                              fontSize: 14.sp,
                            ),
                          ),
                          IconButton(
                            alignment: Alignment.centerRight,
                            onPressed: () {
                              educationAddBtnOnPressed(context);
                            },
                            icon: const Icon(
                              Icons.add_circle_outline,
                              color: kTitleBlack,
                              size: 22.5,
                            ),
                          ),
                        ],
                      ),
                      userEducationList!.isNotEmpty
                          ? ListView.builder(
                              itemBuilder: (context, index) {
                                final Education? currentEducation =
                                    userEducationList![index];
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            currentEducation!.school,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: kTitleBlack,
                                              fontSize: 11.5.sp,
                                            ),
                                          ),
                                          Text(
                                            '${currentEducation.degree} • ${currentEducation.major} \n${currentEducation.startDate} - ${currentEducation.endDate}',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                                color:
                                                    kRegistrationSubtitleGrey,
                                                fontSize: 9.5.sp),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      alignment: Alignment.centerRight,
                                      onPressed: () {
                                        educationUpdateBtnOnPressed(
                                            context: context,
                                            subCollectionId: currentEducation
                                                .subCollectionId,
                                            listIndex: index);
                                      },
                                      icon: const Icon(
                                        Icons.arrow_forward_ios,
                                        color: kRegistrationSubtitleGrey,
                                        size: 23.5,
                                      ),
                                    ),
                                  ],
                                );
                              },
                              itemCount: userEducationList!.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                            )
                          : Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Create your first education . . .',
                                style: TextStyle(
                                    color: kRegistrationSubtitleGrey,
                                    fontSize: 9.5.sp),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 0.8.h,
                vertical: 1.h,
              ),
              child: MyCardWidget(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 1.2.h,
                    right: 1.2.h,
                    bottom: 1.5.h,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Skills',
                            style: TextStyle(
                              color: kTitleBlack,
                              fontSize: 14.sp,
                            ),
                          ),
                          IconButton(
                            alignment: Alignment.centerRight,
                            onPressed: () {
                              skillAddBtnOnPressed(context);
                            },
                            icon: const Icon(
                              Icons.add_circle_outline,
                              color: kTitleBlack,
                              size: 22.5,
                            ),
                          ),
                        ],
                      ),
                      userSkillList!.isNotEmpty
                          ? ListView.builder(
                              itemBuilder: (context, index) {
                                final Skill? currentSkill =
                                    userSkillList![index];
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            currentSkill!.skillName,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: kTitleBlack,
                                              fontSize: 11.5.sp,
                                            ),
                                          ),
                                          Text(
                                            currentSkill.skillLevel,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                                color:
                                                    kRegistrationSubtitleGrey,
                                                fontSize: 9.5.sp),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      alignment: Alignment.centerRight,
                                      onPressed: () {
                                        skillUpdateBtnOnPressed(
                                            context: context,
                                            subCollectionId:
                                                currentSkill.subCollectionId,
                                            listIndex: index);
                                      },
                                      icon: const Icon(
                                        Icons.arrow_forward_ios,
                                        color: kRegistrationSubtitleGrey,
                                        size: 23.5,
                                      ),
                                    ),
                                  ],
                                );
                              },
                              itemCount: userSkillList!.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                            )
                          : Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Create your first skill . . .',
                                style: TextStyle(
                                    color: kRegistrationSubtitleGrey,
                                    fontSize: 9.5.sp),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 0.8.h,
                vertical: 1.h,
              ),
              child: MyCardWidget(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 1.2.h,
                    right: 1.2.h,
                    bottom: 1.5.h,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Autism Challenges',
                            style: TextStyle(
                              color: kTitleBlack,
                              fontSize: 14.sp,
                            ),
                          ),
                          IconButton(
                            alignment: Alignment.centerRight,
                            onPressed: () {
                              autismChallengeAddBtnOnPressed(context);
                            },
                            icon: const Icon(
                              Icons.add_circle_outline,
                              color: kTitleBlack,
                              size: 22.5,
                            ),
                          ),
                        ],
                      ),
                      userAutismChallengeList!.isNotEmpty
                          ? ListView.builder(
                              itemBuilder: (context, index) {
                                final AutismChallenge? currentAutismChallenge =
                                    userAutismChallengeList![index];
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            currentAutismChallenge!
                                                .challengeName,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: kTitleBlack,
                                              fontSize: 11.5.sp,
                                            ),
                                          ),
                                          Text(
                                            currentAutismChallenge
                                                .challengeLevel,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                                color:
                                                    kRegistrationSubtitleGrey,
                                                fontSize: 9.5.sp),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      alignment: Alignment.centerRight,
                                      onPressed: () {
                                        autismChallengeUpdateBtnOnPressed(
                                            context: context,
                                            subCollectionId:
                                                currentAutismChallenge
                                                    .subCollectionId,
                                            listIndex: index);
                                      },
                                      icon: const Icon(
                                        Icons.arrow_forward_ios,
                                        color: kRegistrationSubtitleGrey,
                                        size: 23.5,
                                      ),
                                    ),
                                  ],
                                );
                              },
                              itemCount: userAutismChallengeList!.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                            )
                          : Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Create your first autism challenge . . .',
                                style: TextStyle(
                                    color: kRegistrationSubtitleGrey,
                                    fontSize: 9.5.sp),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.2.h),
          child: SizedBox(
            height: 6.25.h,
            child: ResumeBuilderButton(
              onPressed: () async {
                final Resume userResume = Resume(
                  userPersonalDetails: userPersonalDetails,
                  userProfessionalSummary: userProfessionalSummary,
                  userEmploymentHistoryList: userEmploymentHistoryList!,
                  userEducationList: userEducationList!,
                  userSkillList: userSkillList!,
                  userAutismChallengeList: userAutismChallengeList!,
                );

                final resumePdfFile = await ResumePdfApi.generate(userResume);

                //PdfApi.openFile(resumePdfFile);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AsdPdfViewerScreen(file: resumePdfFile),
                  ),
                );
              },
              isHollow: false,
              child: Text(
                'Resume Preview',
                style: TextStyle(
                  fontSize: 12.5.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
