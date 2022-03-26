import 'package:autism_bridge/apis/resume_pdf_api.dart';
import 'package:autism_bridge/models/asd_user_credentials.dart';
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
import 'package:autism_bridge/widgets/my_gradient_container.dart';
import 'package:autism_bridge/widgets/resume_builder_button.dart';
import 'package:autism_bridge/widgets/rounded_icon_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../color_constants.dart';

class AsdResumeBuilderScreen extends StatefulWidget {
  static const id = 'asd_resume_builder_screen';

  final AsdUserCredentials asdUserCredentials;

  final Resume userResume;

  const AsdResumeBuilderScreen({
    Key? key,
    required this.asdUserCredentials,
    required this.userResume,
  }) : super(key: key);

  @override
  _AsdResumeBuilderScreenState createState() => _AsdResumeBuilderScreenState();
}

class _AsdResumeBuilderScreenState extends State<AsdResumeBuilderScreen> {
  final sectionRatio = 1 / 5;

  double profileCompleteness = 0.0;

  bool isPersonalDetailsComplete = false;

  bool isProfessionalSummaryComplete = false;

  bool isEmploymentHistoryComplete = false;

  bool isEducationComplete = false;

  bool isSkillComplete = false;

  bool isAutismChallengeComplete = false;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.userResume.userPersonalDetails != null) {
      profileCompleteness += sectionRatio;
      isPersonalDetailsComplete = true;
    }

    if (widget.userResume.userProfessionalSummary != null) {
      profileCompleteness += sectionRatio;
      isProfessionalSummaryComplete = true;
    }

    if (widget.userResume.userEmploymentHistoryList.isNotEmpty) {
      profileCompleteness += sectionRatio;
      isEmploymentHistoryComplete = true;
    }

    if (widget.userResume.userEducationList.isNotEmpty) {
      profileCompleteness += sectionRatio;
      isEducationComplete = true;
    }

    if (widget.userResume.userSkillList.isNotEmpty) {
      profileCompleteness += sectionRatio;
      isSkillComplete = true;
    }

    if (widget.userResume.userAutismChallengeList.isNotEmpty) {
      //profileCompleteness += sectionRatio;
      isAutismChallengeComplete = true;
    }
  }

  Future<void> autismChallengeAddBtnOnPressed(BuildContext context) async {
    final List<AutismChallenge?>? updatedAutismChallengeList =
        await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AsdAutismChallengesScreen(
          asdUserCredentials: widget.asdUserCredentials,
          isAddingNew: true,
          userResume: widget.userResume,
        ),
      ),
    );

    if (updatedAutismChallengeList != null) {
      setState(() {
        widget.userResume.setAutismChallengeList = updatedAutismChallengeList;
      });
      if (!isAutismChallengeComplete) {
        isAutismChallengeComplete = true;
        // setState(() {
        //   profileCompleteness += sectionRatio;
        // });
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
          asdUserCredentials: widget.asdUserCredentials,
          isAddingNew: false,
          subCollectionId: subCollectionId,
          listIndex: listIndex,
          userResume: widget.userResume,
        ),
      ),
    );

    if (updatedSkillList != null) {
      setState(() {
        widget.userResume.setSkillList = updatedSkillList;
      });
      if (updatedSkillList.isEmpty) {
        setState(() {
          isSkillComplete = false;
          profileCompleteness -= sectionRatio;
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
          asdUserCredentials: widget.asdUserCredentials,
          isAddingNew: false,
          subCollectionId: subCollectionId,
          listIndex: listIndex,
          userResume: widget.userResume,
        ),
      ),
    );

    if (updatedAutismChallengeList != null) {
      setState(() {
        widget.userResume.setAutismChallengeList = updatedAutismChallengeList;
      });
      if (updatedAutismChallengeList.isEmpty) {
        setState(() {
          isAutismChallengeComplete = false;
          //profileCompleteness -= sectionRatio;
        });
      }
    }
  }

  Future<void> skillAddBtnOnPressed(BuildContext context) async {
    final List<Skill?>? updatedSkillList = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AsdSkillsScreen(
          asdUserCredentials: widget.asdUserCredentials,
          isAddingNew: true,
          userResume: widget.userResume,
        ),
      ),
    );

    if (updatedSkillList != null) {
      setState(() {
        widget.userResume.setSkillList = updatedSkillList;
      });
      if (!isSkillComplete) {
        isSkillComplete = true;
        setState(() {
          profileCompleteness += sectionRatio;
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
          asdUserCredentials: widget.asdUserCredentials,
          isAddingNew: false,
          subCollectionId: subCollectionId,
          listIndex: listIndex,
          userResume: widget.userResume,
        ),
      ),
    );

    if (updatedEducationList != null) {
      setState(() {
        widget.userResume.setEducationList = updatedEducationList;
      });
      if (updatedEducationList.isEmpty) {
        setState(() {
          isEducationComplete = false;
          profileCompleteness -= sectionRatio;
        });
      }
    }
  }

  Future<void> educationAddBtnOnPressed(BuildContext context) async {
    final List<Education?>? updatedEducationList = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AsdEducationScreen(
          asdUserCredentials: widget.asdUserCredentials,
          isAddingNew: true,
          userResume: widget.userResume,
        ),
      ),
    );

    if (updatedEducationList != null) {
      setState(() {
        widget.userResume.setEducationList = updatedEducationList;
      });
      if (!isEducationComplete) {
        isEducationComplete = true;
        setState(() {
          profileCompleteness += sectionRatio;
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
          asdUserCredentials: widget.asdUserCredentials,
          isAddingNew: false,
          subCollectionId: subCollectionId,
          listIndex: listIndex,
          userResume: widget.userResume,
        ),
      ),
    );

    if (updatedEmploymentHistoryList != null) {
      setState(() {
        widget.userResume.setEmploymentHistoryList =
            updatedEmploymentHistoryList;
      });
      if (updatedEmploymentHistoryList.isEmpty) {
        setState(() {
          isEmploymentHistoryComplete = false;
          profileCompleteness -= sectionRatio;
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
          asdUserCredentials: widget.asdUserCredentials,
          isAddingNew: true,
          userResume: widget.userResume,
        ),
      ),
    );

    if (updatedEmploymentHistoryList != null) {
      setState(() {
        widget.userResume.setEmploymentHistoryList =
            updatedEmploymentHistoryList;
      });
      if (!isEmploymentHistoryComplete) {
        isEmploymentHistoryComplete = true;
        setState(() {
          profileCompleteness += sectionRatio;
        });
      }
    }
  }

  Future<void> personalDetailsBtnOnPressed(BuildContext context) async {
    final PersonalDetails? updatedPersonalDetails = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AsdPersonalDetailsScreen(
          asdUserCredentials: widget.asdUserCredentials,
          userResume: widget.userResume,
          isFirstTimeIn: false,
        ),
      ),
    );

    // Return non-null means changes have made in AsdPersonalDetailsScreen
    // so update the userPersonalDetails to updatedPersonalDetails
    if (updatedPersonalDetails != null) {
      setState(() {
        widget.userResume.setPersonalDetails = updatedPersonalDetails;
      });
      if (!isPersonalDetailsComplete) {
        isPersonalDetailsComplete = true;
        setState(() {
          profileCompleteness += sectionRatio;
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
          asdUserCredentials: widget.asdUserCredentials,
          userResume: widget.userResume,
        ),
      ),
    );

    // Return non-null means changes have made in AsdPersonalDetailsScreen
    // so update the userPersonalDetails to updatedPersonalDetails
    if (updatedProfessionalSummary != null) {
      setState(() {
        widget.userResume.setProfessionalSummary = updatedProfessionalSummary;
      });
      if (!isProfessionalSummaryComplete) {
        isProfessionalSummaryComplete = true;
        setState(() {
          profileCompleteness += sectionRatio;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget seg = SizedBox(height: 1.5.h);
    final Widget littleSeg = SizedBox(height: 0.3.h);
    final TextStyle titleTextStyle = TextStyle(
      color: kTitleBlack,
      fontSize: 14.5.sp,
    );
    final TextStyle subTitleTextStyle = TextStyle(
      color: kTitleBlack,
      fontSize: 11.5.sp,
    );
    final TextStyle bodyTextStyle =
        TextStyle(color: kRegistrationSubtitleGrey, fontSize: 9.sp);
    final Text colonText = Text(
      ':',
      style: bodyTextStyle,
    );
    const double arrowBtnSize = 20.5;
    return MyGradientContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: const Text(
            'Resume Builder',
            style: TextStyle(
                //fontWeight: FontWeight.w600,
                //letterSpacing: 0.6,
                color: kTitleBlack),
          ),
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
              Navigator.pop(context, widget.userResume);
            },
            margin: EdgeInsets.all(1.35.h),
          ),
          leadingWidth: 14.8.w,
        ),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: 1.h,
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
                        ' Resume   Completeness',
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
                  backgroundColor: kAutismBridgeBlue.withOpacity(0.17),
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
                ),
                child: MyCardWidget(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 1.5.h,
                      vertical: 1.5.h,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.userResume.userPersonalDetails ==
                                            null
                                        ? 'Personal Details'
                                        : '${widget.userResume.userPersonalDetails!.firstName} ${widget.userResume.userPersonalDetails!.lastName}',
                                    style: titleTextStyle,
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  RoundedIconContainer(
                                    onPressed: () {
                                      personalDetailsBtnOnPressed(context);
                                    },
                                    childIcon: const Icon(
                                      Icons.edit_rounded,
                                      size: 18,
                                      color: kClickableIconBlue,
                                    ),
                                    color: const Color(0xFF000000)
                                        .withOpacity(0.05),
                                    margin: EdgeInsets.only(
                                        top: 1.2.h,
                                        bottom: 1.2.h,
                                        right: 0.6.h),
                                  ),
                                ],
                              ),
                              CircleAvatar(
                                radius: 38,
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(100.0), //or 15.0
                                  child: Container(
                                    height: double.infinity,
                                    width: double.infinity,
                                    color: kBackgroundRiceWhite,
                                    child:
                                        widget.userResume.userPersonalDetails ==
                                                null
                                            ? const Icon(
                                                CupertinoIcons.person_alt,
                                                color: Color(0xFFBEC4D5),
                                                size: 40.0,
                                              )
                                            : FittedBox(
                                                child: Image.file(widget
                                                    .userResume
                                                    .userPersonalDetails!
                                                    .profileImage),
                                                fit: BoxFit.fill,
                                              ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          widget.userResume.userPersonalDetails == null
                              ? const SizedBox.shrink()
                              : Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 0.82.h),
                                          child: const Icon(
                                            Icons.phone,
                                            color: kRegistrationSubtitleGrey,
                                            size: 14.7,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 0.82.h),
                                          child: const Icon(
                                            Icons.email,
                                            color: kRegistrationSubtitleGrey,
                                            size: 14.7,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 0.82.h),
                                          child: const Icon(
                                            Icons.cake,
                                            color: kRegistrationSubtitleGrey,
                                            size: 14.7,
                                          ),
                                        ),
                                        const Icon(
                                          Icons.location_city,
                                          color: kRegistrationSubtitleGrey,
                                          size: 14.7,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 1.h,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Phone',
                                          style: bodyTextStyle,
                                        ),
                                        littleSeg,
                                        Text(
                                          'Email',
                                          style: bodyTextStyle,
                                        ),
                                        littleSeg,
                                        Text(
                                          'Birth',
                                          style: bodyTextStyle,
                                        ),
                                        littleSeg,
                                        Text(
                                          'Current',
                                          style: bodyTextStyle,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Number',
                                          style: bodyTextStyle,
                                        ),
                                        littleSeg,
                                        Text(
                                          'Address',
                                          style: bodyTextStyle,
                                        ),
                                        littleSeg,
                                        Text(
                                          'Date',
                                          style: bodyTextStyle,
                                        ),
                                        littleSeg,
                                        Text(
                                          'City',
                                          style: bodyTextStyle,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 0.8.h,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        colonText,
                                        littleSeg,
                                        colonText,
                                        littleSeg,
                                        colonText,
                                        littleSeg,
                                        colonText,
                                      ],
                                    ),
                                    SizedBox(
                                      width: 0.8.h,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.userResume.userPersonalDetails!
                                              .phone,
                                          style: bodyTextStyle,
                                        ),
                                        littleSeg,
                                        Text(
                                          widget.userResume.userPersonalDetails!
                                              .email,
                                          style: bodyTextStyle,
                                        ),
                                        littleSeg,
                                        Text(
                                          widget.userResume.userPersonalDetails!
                                              .dateOfBirth,
                                          style: bodyTextStyle,
                                        ),
                                        littleSeg,
                                        Text(
                                          '${widget.userResume.userPersonalDetails!.city}, ${widget.userResume.userPersonalDetails!.state}',
                                          style: bodyTextStyle,
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              seg,
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 0.8.h,
                ),
                child: MyCardWidget(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 1.5.h,
                      right: 1.5.h,
                      bottom: 1.5.h,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Professional Summary',
                              style: titleTextStyle,
                            ),
                            RoundedIconContainer(
                              onPressed: () {
                                professionalSummaryBtnOnPressed(context);
                              },
                              childIcon: const Icon(
                                Icons.edit_rounded,
                                size: 18,
                                color: kClickableIconBlue,
                              ),
                              color: const Color(0xFF000000).withOpacity(0.05),
                              margin: EdgeInsets.only(
                                  top: 1.2.h, bottom: 1.2.h, right: 0.6.h),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.userResume.userProfessionalSummary == null
                                ? 'Add your professional summary...'
                                : widget.userResume.userProfessionalSummary!
                                    .summaryText,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: bodyTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              seg,
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 0.8.h,
                ),
                child: MyCardWidget(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 1.5.h,
                      right: 1.5.h,
                      bottom: 1.5.h,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Employment History',
                              style: titleTextStyle,
                            ),
                            RoundedIconContainer(
                              onPressed: () {
                                employmentHistoryAddBtnOnPressed(context);
                              },
                              childIcon: const Icon(
                                Icons.add_rounded,
                                size: 26,
                                color: kClickableIconBlue,
                              ),
                              color: const Color(0xFF000000).withOpacity(0.05),
                              margin: EdgeInsets.only(
                                  top: 1.2.h, bottom: 1.2.h, right: 0.6.h),
                            ),
                          ],
                        ),
                        widget.userResume.userEmploymentHistoryList.isNotEmpty
                            ? ListView.builder(
                                itemBuilder: (context, index) {
                                  final EmploymentHistory?
                                      currentEmploymentHistory = widget
                                          .userResume
                                          .userEmploymentHistoryList[index];
                                  return Padding(
                                    padding: index == 0
                                        ? EdgeInsets.zero
                                        : EdgeInsets.only(
                                            top: 0.75.h,
                                          ),
                                    child: GestureDetector(
                                      onTap: () {
                                        employmentHistoryUpdateBtnOnPressed(
                                          context: context,
                                          subCollectionId:
                                              currentEmploymentHistory!
                                                  .subCollectionId,
                                          listIndex: index,
                                        );
                                      },
                                      behavior: HitTestBehavior.translucent,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  currentEmploymentHistory!
                                                      .employer,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: subTitleTextStyle,
                                                ),
                                                Text(
                                                  '${currentEmploymentHistory.jobTitle}  \n${currentEmploymentHistory.startDate} - ${currentEmploymentHistory.endDate}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: bodyTextStyle,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const IconButton(
                                            alignment: Alignment.centerRight,
                                            onPressed: null,
                                            icon: Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              color: kRegistrationSubtitleGrey,
                                              size: arrowBtnSize,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                itemCount: widget.userResume
                                    .userEmploymentHistoryList.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                              )
                            : Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Create your first employment history . . .',
                                  style: bodyTextStyle,
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
              seg,
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 0.8.h,
                ),
                child: MyCardWidget(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 1.5.h,
                      right: 1.5.h,
                      bottom: 1.5.h,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Education',
                              style: titleTextStyle,
                            ),
                            RoundedIconContainer(
                              onPressed: () {
                                educationAddBtnOnPressed(context);
                              },
                              childIcon: const Icon(
                                Icons.add_rounded,
                                size: 26,
                                color: kClickableIconBlue,
                              ),
                              color: const Color(0xFF000000).withOpacity(0.05),
                              margin: EdgeInsets.only(
                                  top: 1.2.h, bottom: 1.2.h, right: 0.6.h),
                            ),
                          ],
                        ),
                        widget.userResume.userEducationList.isNotEmpty
                            ? ListView.builder(
                                itemBuilder: (context, index) {
                                  final Education? currentEducation = widget
                                      .userResume.userEducationList[index];
                                  return Padding(
                                    padding: index == 0
                                        ? EdgeInsets.zero
                                        : EdgeInsets.only(
                                            top: 0.75.h,
                                          ),
                                    child: GestureDetector(
                                      onTap: () {
                                        educationUpdateBtnOnPressed(
                                            context: context,
                                            subCollectionId: currentEducation!
                                                .subCollectionId,
                                            listIndex: index);
                                      },
                                      behavior: HitTestBehavior.translucent,
                                      child: Row(
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: subTitleTextStyle,
                                                ),
                                                Text(
                                                  '${currentEducation.degree} • ${currentEducation.major} \n${currentEducation.startDate} - ${currentEducation.endDate}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: bodyTextStyle,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const IconButton(
                                            alignment: Alignment.centerRight,
                                            onPressed: null,
                                            icon: Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              color: kRegistrationSubtitleGrey,
                                              size: arrowBtnSize,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                itemCount:
                                    widget.userResume.userEducationList.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                              )
                            : Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Create your first education . . .',
                                  style: bodyTextStyle,
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
              seg,
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 0.8.h,
                ),
                child: MyCardWidget(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 1.5.h,
                      right: 1.5.h,
                      bottom: 1.5.h,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Skills',
                              style: titleTextStyle,
                            ),
                            RoundedIconContainer(
                              onPressed: () {
                                skillAddBtnOnPressed(context);
                              },
                              childIcon: const Icon(
                                Icons.add_rounded,
                                size: 26,
                                color: kClickableIconBlue,
                              ),
                              color: const Color(0xFF000000).withOpacity(0.05),
                              margin: EdgeInsets.only(
                                  top: 1.2.h, bottom: 1.2.h, right: 0.6.h),
                            ),
                          ],
                        ),
                        widget.userResume.userSkillList.isNotEmpty
                            ? ListView.builder(
                                itemBuilder: (context, index) {
                                  final Skill? currentSkill =
                                      widget.userResume.userSkillList[index];
                                  return Padding(
                                    padding: index == 0
                                        ? EdgeInsets.zero
                                        : EdgeInsets.only(
                                            top: 0.75.h,
                                          ),
                                    child: GestureDetector(
                                      onTap: () {
                                        skillUpdateBtnOnPressed(
                                            context: context,
                                            subCollectionId:
                                                currentSkill!.subCollectionId,
                                            listIndex: index);
                                      },
                                      behavior: HitTestBehavior.translucent,
                                      child: Row(
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: subTitleTextStyle,
                                                ),
                                                Text(
                                                  currentSkill.skillLevel,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: bodyTextStyle,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const IconButton(
                                            alignment: Alignment.centerRight,
                                            onPressed: null,
                                            icon: Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              color: kRegistrationSubtitleGrey,
                                              size: arrowBtnSize,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                itemCount:
                                    widget.userResume.userSkillList.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                              )
                            : Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Create your first skill . . .',
                                  style: bodyTextStyle,
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
              seg,
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 0.8.h,
                ),
                child: MyCardWidget(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 1.5.h,
                      right: 1.5.h,
                      bottom: 1.5.h,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // TODO: figure out a better name, 'Challenge' ? 'Workplace Challenge'
                            Row(
                              children: [
                                Text(
                                  'Workplace Challenges',
                                  style: titleTextStyle,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 0.5.h, top: 0.78.h),
                                  child: Text(
                                    '(optional)',
                                    style: TextStyle(
                                      color: kRegistrationSubtitleGrey,
                                      fontSize: 7.5.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            RoundedIconContainer(
                              onPressed: () {
                                autismChallengeAddBtnOnPressed(context);
                              },
                              childIcon: const Icon(
                                Icons.add_rounded,
                                size: 26,
                                color: kClickableIconBlue,
                              ),
                              color: const Color(0xFF000000).withOpacity(0.05),
                              margin: EdgeInsets.only(
                                  top: 1.2.h, bottom: 1.2.h, right: 0.6.h),
                            ),
                          ],
                        ),
                        widget.userResume.userAutismChallengeList.isNotEmpty
                            ? ListView.builder(
                                itemBuilder: (context, index) {
                                  final AutismChallenge?
                                      currentAutismChallenge = widget.userResume
                                          .userAutismChallengeList[index];
                                  return Padding(
                                    padding: index == 0
                                        ? EdgeInsets.zero
                                        : EdgeInsets.only(
                                            top: 0.75.h,
                                          ),
                                    child: GestureDetector(
                                      onTap: () {
                                        autismChallengeUpdateBtnOnPressed(
                                            context: context,
                                            subCollectionId:
                                                currentAutismChallenge!
                                                    .subCollectionId,
                                            listIndex: index);
                                      },
                                      behavior: HitTestBehavior.translucent,
                                      child: Row(
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: subTitleTextStyle,
                                                ),
                                                Text(
                                                  currentAutismChallenge
                                                      .challengeLevel,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: bodyTextStyle,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const IconButton(
                                            alignment: Alignment.centerRight,
                                            onPressed: null,
                                            icon: Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              color: kRegistrationSubtitleGrey,
                                              size: arrowBtnSize,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                itemCount: widget
                                    .userResume.userAutismChallengeList.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                              )
                            : Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Create your first autism challenge . . .',
                                  style: bodyTextStyle,
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
          color: kBackgroundRiceWhite,
          elevation: 0.0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.2.h),
            child: SizedBox(
              height: 6.25.h,
              child: ResumeBuilderButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });

                  final resumePdfFile =
                      await ResumePdfApi.generate(widget.userResume);

                  setState(() {
                    isLoading = false;
                  });

                  //PdfApi.openFile(resumePdfFile);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AsdPdfViewerScreen(
                        file: resumePdfFile,
                        userResume: widget.userResume,
                        asdUserCredentials: widget.asdUserCredentials,
                      ),
                      settings:
                          const RouteSettings(name: AsdResumeBuilderScreen.id),
                    ),
                  );
                },
                isHollow: false,
                child: isLoading
                    ? SizedBox(
                        width: 3.18.h,
                        height: 3.18.h,
                        child: const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                            Colors.white,
                          ),
                        ),
                      )
                    : Text(
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
      ),
    );
  }
}
