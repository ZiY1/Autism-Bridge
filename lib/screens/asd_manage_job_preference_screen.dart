import 'package:autism_bridge/models/asd_user_credentials.dart';
import 'package:autism_bridge/models/job_preference_data.dart';
import 'package:autism_bridge/widgets/my_card_widget.dart';
import 'package:autism_bridge/widgets/my_gradient_container.dart';
import 'package:autism_bridge/widgets/rounded_icon_container.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../constants.dart';
import 'package:dotted_border/dotted_border.dart';
import 'asd_job_preference_screen.dart';

class AsdManageJobPreferenceScreen extends StatefulWidget {
  static const id = 'asd_manage_job_preference_screen';

  final AsdUserCredentials asdUserCredentials;

  final List<JobPreference?> userJobPreferenceList;

  const AsdManageJobPreferenceScreen({
    Key? key,
    required this.asdUserCredentials,
    required this.userJobPreferenceList,
  }) : super(key: key);

  @override
  State<AsdManageJobPreferenceScreen> createState() =>
      _AsdManageJobPreferenceScreenState();
}

class _AsdManageJobPreferenceScreenState
    extends State<AsdManageJobPreferenceScreen> {
  List<JobPreference?>? userJobPreferenceList;

  @override
  void initState() {
    super.initState();

    userJobPreferenceList = widget.userJobPreferenceList;
  }

  Future<void> jobPreferenceUpdateBtnOnPressed(
      {required BuildContext context,
      required String subCollectionId,
      required int listIndex}) async {
    final List<JobPreference?>? updatedJobPreferenceList = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AsdJobPreferenceScreen(
          asdUserCredentials: widget.asdUserCredentials,
          isAddingNew: false,
          subCollectionId: subCollectionId,
          listIndex: listIndex,
          userJobPreferenceList: userJobPreferenceList!,
        ),
      ),
    );

    if (updatedJobPreferenceList != null) {
      setState(() {
        userJobPreferenceList = updatedJobPreferenceList;
      });
    }
  }

  Future<void> jobPreferenceAddNewBtnOnPressed(BuildContext context) async {
    final List<JobPreference?>? updatedJobPreferenceList = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AsdJobPreferenceScreen(
          asdUserCredentials: widget.asdUserCredentials,
          isAddingNew: true,
          userJobPreferenceList: userJobPreferenceList!,
        ),
      ),
    );

    if (updatedJobPreferenceList != null) {
      setState(() {
        userJobPreferenceList = updatedJobPreferenceList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget segEdge = SizedBox(height: 1.h);
    final Widget textButton = Padding(
      padding: EdgeInsets.only(top: 1.5.h),
      child: SizedBox(
        height: 7.h,
        child: DottedBorder(
          color: kAutismBridgeBlue,
          borderType: BorderType.RRect,
          strokeWidth: 1.2,
          dashPattern: const [4.5],
          radius: const Radius.circular(12),
          child: Padding(
            padding: EdgeInsets.only(top: 0.32.h),
            child: TextButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 2.5.h,
                    height: 2.5.h,
                    child: const Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 17,
                    ),
                    margin: EdgeInsets.only(right: 1.h),
                    decoration: const BoxDecoration(
                      color: kAutismBridgeBlue,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Text(
                    'Add Job Preference',
                    style: TextStyle(
                      color: kAutismBridgeBlue,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
              // style: ButtonStyle(
              //   padding: MaterialStateProperty.all<EdgeInsets>(
              //     EdgeInsets.all(1.55.h),
              //   ),
              //   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              //     RoundedRectangleBorder(
              //       borderRadius:
              //           BorderRadius.circular(kResumeBuilderCardRadius),
              //     ),
              //   ),
              //   side: MaterialStateProperty.all<BorderSide>(
              //     const BorderSide(
              //       color: kAutismBridgeBlue,
              //     ),
              //   ),
              // ),
              onPressed: () {
                jobPreferenceAddNewBtnOnPressed(context);
              },
            ),
          ),
        ),
      ),
    );
    return MyGradientContainer(
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
                        Padding(
                          padding: EdgeInsets.only(top: 0.7.h),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: [
                              TextSpan(
                                text: userJobPreferenceList!.length.toString(),
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 10.5.sp,
                                  color: kAutismBridgeBlue,
                                ),
                              ),
                              TextSpan(
                                text: ' /3',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 10.5.sp,
                                  color: const Color(0xFF858597),
                                ),
                              ),
                            ]),
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
                        userJobPreferenceList!.isEmpty
                            ? const SizedBox.shrink()
                            : segEdge,
                        userJobPreferenceList!.isNotEmpty
                            ? ListView.builder(
                                itemBuilder: (context, index) {
                                  final JobPreference? currentJobPreference =
                                      userJobPreferenceList![index];
                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                currentJobPreference!
                                                    .getJobTitle,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: kTitleBlack,
                                                  fontSize: 11.5.sp,
                                                ),
                                              ),
                                              Text(
                                                currentJobPreference
                                                        .getMaxSalary.isEmpty
                                                    ? '${currentJobPreference.getMinSalary}  •  ${currentJobPreference.getJobCity}  •  ${currentJobPreference.getEmploymentType}'
                                                    : '${currentJobPreference.getMinSalary} - ${currentJobPreference.getMaxSalary}  •  ${currentJobPreference.getJobCity}  •  ${currentJobPreference.getEmploymentType}',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color:
                                                        kRegistrationSubtitleGrey,
                                                    fontSize: 9.sp),
                                              ),
                                            ],
                                          ),
                                          IconButton(
                                            alignment: Alignment.centerRight,
                                            onPressed: () {
                                              jobPreferenceUpdateBtnOnPressed(
                                                  context: context,
                                                  subCollectionId:
                                                      currentJobPreference
                                                          .getSubCollectionId,
                                                  listIndex: index);
                                            },
                                            icon: const Icon(
                                              Icons.arrow_forward_ios,
                                              color: kRegistrationSubtitleGrey,
                                              size: 20.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                      index == userJobPreferenceList!.length - 1
                                          ? const SizedBox.shrink()
                                          : Divider(
                                              height: 2.2.h,
                                              thickness: 0.95,
                                              color: const Color(0xFFF0F0F2),
                                            ),
                                    ],
                                  );
                                },
                                itemCount: userJobPreferenceList!.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                              )
                            : const SizedBox.shrink(),
                        userJobPreferenceList!.isEmpty
                            ? textButton
                            : const SizedBox.shrink(),
                        userJobPreferenceList!.isNotEmpty &&
                                userJobPreferenceList!.length < 3
                            ? textButton
                            : const SizedBox.shrink(),
                        segEdge,
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
