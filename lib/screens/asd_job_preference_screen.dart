import 'package:autism_bridge/icon_constants.dart';
import 'package:autism_bridge/models/asd_user_credentials.dart';
import 'package:autism_bridge/models/job_preference_data.dart';
import 'package:autism_bridge/models/job_matching_picker_list.dart';
import 'package:autism_bridge/models/resume_data.dart';
import 'package:autism_bridge/regular_helpers.dart';
import 'package:autism_bridge/screens/asd_home_screen.dart';
import 'package:autism_bridge/widgets/my_card_widget.dart';
import 'package:autism_bridge/widgets/my_gradient_container.dart';
import 'package:autism_bridge/widgets/resume_builder_button.dart';
import 'package:autism_bridge/widgets/input_holder.dart';
import 'package:autism_bridge/widgets/rounded_icon_container.dart';
import 'package:autism_bridge/widgets/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../color_constants.dart';
import 'package:autism_bridge/modified_flutter_packages/picker_from_pack.dart';

import '../num_constants.dart';

class AsdJobPreferenceScreen extends StatefulWidget {
  static const id = 'asd_job_preference_screen';

  final AsdUserCredentials asdUserCredentials;

  final bool isAddingNew;

  final String? subCollectionId;

  final int? listIndex;

  final List<JobPreference?> userJobPreferenceList;

  final bool isFirstTimeIn;

  final Resume? userResume;

  const AsdJobPreferenceScreen({
    Key? key,
    required this.asdUserCredentials,
    required this.isAddingNew,
    this.subCollectionId,
    this.listIndex,
    required this.userJobPreferenceList,
    required this.isFirstTimeIn,
    this.userResume,
  }) : super(key: key);

  @override
  State<AsdJobPreferenceScreen> createState() => _AsdJobPreferenceScreenState();
}

class _AsdJobPreferenceScreenState extends State<AsdJobPreferenceScreen> {
  List<JobPreference?>? userJobPreferenceList;

  String? preferredEmploymentType;

  String? preferredJobCategory;

  String? preferredJobTitle;

  String? preferredCity;

  String? preferredState;

  double? preferredMinSalary;

  double? preferredMaxSalary;

  bool isSaving = false;

  bool isDeleting = false;

  String btnText = 'Add';

  @override
  void initState() {
    super.initState();

    List<JobPreference?> jobPreferenceListTemp = widget.userJobPreferenceList;

    userJobPreferenceList = jobPreferenceListTemp;

    if (!widget.isAddingNew) {
      btnText = 'Save';

      if (userJobPreferenceList![widget.listIndex!] != null) {
        JobPreference? jobPreferenceTemp =
            jobPreferenceListTemp[widget.listIndex!];

        preferredEmploymentType = jobPreferenceTemp!.getEmploymentType;
        preferredJobCategory = jobPreferenceTemp.getJobCategory;
        preferredJobTitle = jobPreferenceTemp.getJobTitle;
        preferredCity = jobPreferenceTemp.getJobCity;
        preferredState = jobPreferenceTemp.getJobState;
        preferredMinSalary = jobPreferenceTemp.getMinSalary;
        preferredMaxSalary = jobPreferenceTemp.getMaxSalary;
      }
    }
  }

  Future<void> deleteBtnOnPressed(BuildContext context) async {
    bool wantDelete = await Utils.showMyDialog(context);

    if (wantDelete) {
      setState(() {
        isDeleting = true;
      });

      try {
        await JobPreference.deleteJobPreferenceToFirestore(
          userId: widget.asdUserCredentials.userId,
          // it won't be null because by entering the delete mode, we will pass the subCollectionId
          mySubCollectionId: widget.subCollectionId!,
        );
      } on FirebaseException catch (e) {
        Utils.showSnackBar(
          e.message,
          kErrorIcon,
        );
        return;
      }

      userJobPreferenceList!.removeAt(widget.listIndex!);

      setState(() {
        isDeleting = false;
      });

      Navigator.pop(context, userJobPreferenceList);
    }
  }

  Future<void> saveAddBtnOnPressed(BuildContext context) async {
    //Ensure all fields are not null
    if (preferredEmploymentType == null || preferredEmploymentType!.isEmpty) {
      Utils.showSnackBar(
        'Please enter your desired employment type',
        kErrorIcon,
      );
      return;
    }
    if (preferredJobCategory == null ||
        preferredJobCategory!.isEmpty ||
        preferredJobTitle == null ||
        preferredJobTitle!.isEmpty) {
      Utils.showSnackBar(
        'Please select your desired job categories & title',
        kErrorIcon,
      );
      return;
    }
    if (preferredCity == null ||
        preferredCity!.isEmpty ||
        preferredState == null ||
        preferredState!.isEmpty) {
      Utils.showSnackBar(
        'Please select your desired city & state to work',
        kErrorIcon,
      );
      return;
    }
    if (preferredMinSalary == null || preferredMaxSalary == null) {
      Utils.showSnackBar(
        'Please select your desired salary range',
        kErrorIcon,
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    await handleDataInFirebase();

    setState(() {
      isSaving = false;
    });

    if (widget.isFirstTimeIn) {
      // Update isFirstTimeIn to false in all_users collection
      try {
        await FirebaseFirestore.instance
            .collection('all_users')
            .doc(widget.asdUserCredentials.userId)
            .update({
          'isFirstTimeIn': false,
        });

        // Update isFirstTimeIn to false in job_seeker_users collection
        await FirebaseFirestore.instance
            .collection('job_seeker_users')
            .doc(widget.asdUserCredentials.userId)
            .update({
          'isFirstTimeIn': false,
        });
      } on FirebaseException catch (e) {
        Utils.showSnackBar(
          e.message,
          const Icon(
            Icons.error_sharp,
            color: Colors.red,
            size: 30.0,
          ),
        );
        return;
      }

      // Update the userCredential class
      widget.asdUserCredentials.setIsFirstTimeIn = false;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => AsdHomeScreen(
            asdUserCredentials: widget.asdUserCredentials,
            userResume: widget.userResume!,
            userJobPreferenceList: userJobPreferenceList!,
          ),
        ),
        (route) => false,
      );
    } else {
      Navigator.pop(context, userJobPreferenceList);
    }
  }

  Future<void> handleDataInFirebase() async {
    // Create the JobPreference class
    JobPreference jobPreference;

    if (widget.isAddingNew) {
      // Add the data in firestore

      // When creating, we use timestamp as unique id
      jobPreference = JobPreference(
        userId: widget.asdUserCredentials.userId,
        subCollectionId: DateTime.now().microsecondsSinceEpoch.toString(),
        employmentType: preferredEmploymentType!,
        jobCategory: preferredJobCategory!,
        jobTitle: preferredJobTitle!,
        jobCity: preferredCity!,
        jobState: preferredState!,
        minSalary: preferredMinSalary!,
        maxSalary: preferredMaxSalary!,
      );

      // Add in firestore
      try {
        await jobPreference.addJobPreferenceToFirestore();
      } on FirebaseException catch (e) {
        Utils.showSnackBar(
          e.message,
          const Icon(
            Icons.error_sharp,
            color: Colors.red,
            size: 30.0,
          ),
        );
        return;
      }

      // Update the list userJobPreferenceList
      userJobPreferenceList!.add(jobPreference);
    } else {
      // Update the data (subcolectionId) in firestore
      // make sure subCollectionId is not null

      // When updating, we don't update the timestamp
      jobPreference = JobPreference(
        userId: widget.asdUserCredentials.userId,
        subCollectionId: widget.subCollectionId!,
        employmentType: preferredEmploymentType!,
        jobCategory: preferredJobCategory!,
        jobTitle: preferredJobTitle!,
        jobCity: preferredCity!,
        jobState: preferredState!,
        minSalary: preferredMinSalary!,
        maxSalary: preferredMaxSalary!,
      );
      try {
        await jobPreference.updateJobPreferenceToFirestore();
      } on FirebaseException catch (e) {
        Utils.showSnackBar(
          e.message,
          const Icon(
            Icons.error_sharp,
            color: Colors.red,
            size: 30.0,
          ),
        );
        return;
      }

      // Update the list userJobPreferenceList
      // Ensure listIndex is not null
      userJobPreferenceList![widget.listIndex!] = jobPreference;
    }
  }

  void showEmpTypePicker() {
    Utils.showMyCustomizedPicker(
      context: context,
      pickerData: employmentTypeList,
      onConfirm: (Picker picker, List value) {
        String strTemp = picker.adapter.text;
        String strTempRemovedBracket = strTemp.substring(1, strTemp.length - 1);
        setState(() {
          preferredEmploymentType = strTempRemovedBracket;
        });
      },
      smallerText: false,
    );
  }

  void showJobTitlePicker() {
    Utils.showMyCustomizedPicker(
      context: context,
      pickerData: jobTitleCategoriesList,
      onConfirm: (Picker picker, List value) {
        String strTemp = picker.adapter.text;
        String strTempRemovedBracket = strTemp.substring(1, strTemp.length - 1);

        List tempList = strTempRemovedBracket.split(',');
        String leftValueTemp = tempList[0];
        String rightValueTempWithWhiteSpace = tempList[1];
        String rightValueTemp = rightValueTempWithWhiteSpace.substring(
            1, rightValueTempWithWhiteSpace.length);
        setState(() {
          preferredJobCategory = leftValueTemp;
          preferredJobTitle = rightValueTemp;
        });
      },
      smallerText: true,
    );
  }

  void showCityStatePicker() {
    Utils.showMyCustomizedPicker(
      context: context,
      pickerData: usStatesCitiesList,
      onConfirm: (Picker picker, List value) {
        String strTemp = picker.adapter.text;
        String strTempRemovedBracket = strTemp.substring(1, strTemp.length - 1);

        List tempList = strTempRemovedBracket.split(',');
        String leftValueTemp = tempList[0];
        String rightValueTempWithWhiteSpace = tempList[1];
        String rightValueTemp = rightValueTempWithWhiteSpace.substring(
            1, rightValueTempWithWhiteSpace.length);
        setState(() {
          preferredState = leftValueTemp;
          preferredCity = rightValueTemp;
        });
      },
      smallerText: false,
    );
  }

  void showSalaryRangePicker() {
    Utils.showMyCustomizedPicker(
      context: context,
      pickerData: salaryRageList,
      onConfirm: (Picker picker, List value) {
        String strTemp = picker.adapter.text;
        String strTempRemovedBracket = strTemp.substring(1, strTemp.length - 1);

        List tempList = strTempRemovedBracket.split(',');
        String leftValueTemp = tempList[0];
        String rightValueTempWithWhiteSpace = tempList[1];
        String rightValueTemp = rightValueTempWithWhiteSpace.substring(
            1, rightValueTempWithWhiteSpace.length);
        setState(() {
          preferredMinSalary =
              RegularHelpers.getSalaryAsNumberStr(leftValueTemp);
          preferredMaxSalary =
              RegularHelpers.getSalaryAsNumberStr(rightValueTemp);
        });
      },
      smallerText: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget seg = SizedBox(height: 1.h);
    return MyGradientContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: widget.isFirstTimeIn
            ? null
            : AppBar(
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                iconTheme: const IconThemeData(
                  color: kTitleBlack,
                ),
                leading: RoundedIconContainer(
                  childIcon: const Icon(
                    Icons.close_rounded,
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
              widget.isFirstTimeIn
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 1.h,
                            vertical: 1.h,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'My Job Preference',
                                style: TextStyle(
                                    color: kTitleBlack,
                                    fontSize: 23.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 0.7.h),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: '2',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 18.5.sp,
                                        color: kAutismBridgeBlue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' /2',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 18.5.sp,
                                        color: const Color(0xFF858597),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 1.h,
                            right: 1.h,
                            bottom: 2.h,
                          ),
                          child: Text(
                            'Start getting desired jobs by adding your job preference',
                            style: TextStyle(
                              color: kRegistrationSubtitleGrey,
                              fontSize: 9.5.sp,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 1.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Edit Job Preference',
                                style: TextStyle(
                                    color: kTitleBlack,
                                    fontSize: 19.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 1.h, right: 1.h, bottom: 1.h),
                          child: Text(
                            'We will recommend various job positions \nbased on your job preference',
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
                      //horizontal: 1.5.h,
                      vertical: 1.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        seg,
                        InputHolder(
                          onPressed: () {
                            showEmpTypePicker();
                          },
                          title: 'Desired Employment Type',
                          bodyText: preferredEmploymentType,
                          hintText: 'Select your employment type',
                          disableBorder: false,
                        ),
                        seg,
                        InputHolder(
                          onPressed: () {
                            showJobTitlePicker();
                          },
                          title: 'Desired Job Category & Title',
                          bodyText: preferredJobCategory == null &&
                                  preferredJobTitle == null
                              ? null
                              : '${preferredJobCategory!} , ${preferredJobTitle!}',
                          hintText: 'Select your category & job title',
                          disableBorder: false,
                        ),
                        seg,
                        InputHolder(
                          onPressed: () {
                            showCityStatePicker();
                          },
                          title: 'Desired City & State',
                          bodyText:
                              preferredState == null && preferredCity == null
                                  ? null
                                  : '${preferredCity!} , ${preferredState!}',
                          hintText: 'Select your city & state',
                          disableBorder: false,
                        ),
                        seg,
                        InputHolder(
                          onPressed: () {
                            showSalaryRangePicker();
                          },
                          title: 'Desired Monthly Salary',
                          bodyText: preferredMinSalary == null &&
                                  preferredMaxSalary == null
                              ? null
                              : preferredMaxSalary! == kEmpty
                                  ? preferredMinSalary == kNone
                                      ? 'None'
                                      : preferredMinSalary == kMinSalaryLimit
                                          ? '< ${preferredMinSalary}k'
                                          : '> ${preferredMinSalary}k'
                                  : '${preferredMinSalary!}k - ${preferredMaxSalary!}k',
                          hintText: 'Select your monthly salary range',
                          disableBorder: true,
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
              child: widget.isAddingNew
                  ? widget.isFirstTimeIn
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: ResumeBuilderButton(
                                child: Text(
                                  'Back',
                                  style: TextStyle(
                                    fontSize: 12.5.sp,
                                    color: kAutismBridgeBlue,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context, widget.userResume);
                                },
                                isHollow: true,
                              ),
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            Expanded(
                              child: ResumeBuilderButton(
                                child: isSaving
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
                                        'Save',
                                        style: TextStyle(
                                          fontSize: 12.5.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                onPressed: isSaving
                                    ? null
                                    : () {
                                        saveAddBtnOnPressed(context);
                                      },
                                isHollow: false,
                              ),
                            ),
                          ],
                        )
                      : ResumeBuilderButton(
                          child: isSaving
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
                                  btnText,
                                  style: TextStyle(
                                    fontSize: 12.5.sp,
                                    color: Colors.white,
                                  ),
                                ),
                          onPressed: isSaving
                              ? null
                              : () {
                                  saveAddBtnOnPressed(context);
                                },
                          isHollow: false,
                        )
                  : userJobPreferenceList!.length == 1
                      ? ResumeBuilderButton(
                          child: isSaving
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
                                  btnText,
                                  style: TextStyle(
                                    fontSize: 12.5.sp,
                                    color: Colors.white,
                                  ),
                                ),
                          onPressed: isSaving
                              ? null
                              : () {
                                  saveAddBtnOnPressed(context);
                                },
                          isHollow: false,
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: ResumeBuilderButton(
                                child: isDeleting
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
                                        'Delete',
                                        style: TextStyle(
                                          fontSize: 12.5.sp,
                                          color: kAutismBridgeBlue,
                                        ),
                                      ),
                                onPressed: isDeleting
                                    ? null
                                    : () {
                                        deleteBtnOnPressed(context);
                                      },
                                isHollow: true,
                              ),
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            Expanded(
                              child: ResumeBuilderButton(
                                child: isSaving
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
                                        btnText,
                                        style: TextStyle(
                                          fontSize: 12.5.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                onPressed: isSaving
                                    ? null
                                    : () {
                                        saveAddBtnOnPressed(context);
                                      },
                                isHollow: false,
                              ),
                            ),
                          ],
                        ),
            ),
          ),
        ),
      ),
    );
  }
}
