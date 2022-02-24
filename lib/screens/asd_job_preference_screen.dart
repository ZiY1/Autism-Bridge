import 'dart:convert';

import 'package:autism_bridge/models/personal_details_data.dart';
import 'package:autism_bridge/models/resume_builder_picker_list.dart';
import 'package:autism_bridge/models/job_preference_picker_list.dart';
import 'package:autism_bridge/widgets/my_card_widget.dart';
import 'package:autism_bridge/widgets/resume_builder_button.dart';
import 'package:autism_bridge/widgets/resume_builder_input_field.dart';
import 'package:autism_bridge/widgets/resume_builder_picker.dart';
import 'package:autism_bridge/widgets/rounded_icon_container.dart';
import 'package:autism_bridge/widgets/utils.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../constants.dart';
import '../firebase_helpers.dart';
import 'package:flutter_picker/flutter_picker.dart';

class AsdJobPreferenceScreen extends StatefulWidget {
  static const id = 'asd_job_preference_screen';

  final String userFirstName;

  final String userLastName;

  final String userEmail;

  final String userId;

  //final PersonalDetails? userPersonalDetails;

  const AsdJobPreferenceScreen({
    Key? key,
    required this.userFirstName,
    required this.userLastName,
    required this.userEmail,
    required this.userId,
    //required this.userPersonalDetails,
  }) : super(key: key);

  @override
  State<AsdJobPreferenceScreen> createState() => _AsdJobPreferenceScreenState();
}

class _AsdJobPreferenceScreenState extends State<AsdJobPreferenceScreen> {
  //PersonalDetails? userPersonalDetails;

  String? preferredEmploymentType;

  String? preferredJobTitle;

  String? preferredJobCategory;

  String? preferredState;

  String? preferredCity;

  String? preferredMinSalary;

  String? preferredMaxSalary;

  bool isSaving = false;

  final Widget seg = SizedBox(height: 1.h);

  @override
  void initState() {
    super.initState();

    // PersonalDetails? personalDetailsTemp = widget.userPersonalDetails;
    // if (personalDetailsTemp != null) {
    //   userPersonalDetails = personalDetailsTemp;
    //   wantedJobTitle = personalDetailsTemp.wantedJobTitle;
    //   profileImage = personalDetailsTemp.profileImage;
    //   profileImageUrl = personalDetailsTemp.profileImageUrl;
    //   firstName = personalDetailsTemp.firstName;
    //   lastName = personalDetailsTemp.lastName;
    //   dateOfBirth = personalDetailsTemp.dateOfBirth;
    //   email = personalDetailsTemp.email;
    //   phone = personalDetailsTemp.phone;
    //   country = personalDetailsTemp.country;
    //   city = personalDetailsTemp.city;
    //   address = personalDetailsTemp.address;
    //   postalCode = personalDetailsTemp.postalCode;
    //
    //   selectedDate = DateFormat('MM/dd/yyyy').parse(dateOfBirth!);
    // }
  }

  Future<void> saveButtonOnPressed() async {
    // Ensure all fields are not null

    // if (wantedJobTitle == null || wantedJobTitle!.isEmpty) {
    //   Utils.showSnackBar(
    //     'Please enter your wanted job title',
    //     const Icon(
    //       Icons.error_sharp,
    //       color: Colors.red,
    //       size: 30.0,
    //     ),
    //   );
    //   return;
    // }
    // if (profileImage == null) {
    //   Utils.showSnackBar(
    //     'Please upload your profile photo',
    //     const Icon(
    //       Icons.error_sharp,
    //       color: Colors.red,
    //       size: 30.0,
    //     ),
    //   );
    //   return;
    // }
    // if (firstName == null || firstName!.isEmpty) {
    //   Utils.showSnackBar(
    //     'Please enter your first name',
    //     const Icon(
    //       Icons.error_sharp,
    //       color: Colors.red,
    //       size: 30.0,
    //     ),
    //   );
    //   return;
    // }
    // if (lastName == null || lastName!.isEmpty) {
    //   Utils.showSnackBar(
    //     'Please enter your last name',
    //     const Icon(
    //       Icons.error_sharp,
    //       color: Colors.red,
    //       size: 30.0,
    //     ),
    //   );
    //   return;
    // }

    setState(() {
      isSaving = true;
    });

    //await handleDataInFirebase();

    setState(() {
      isSaving = false;
    });

    //Navigator.pop(context, userPersonalDetails);

    // save it to firebase
  }

  // Future<void> handleDataInFirebase() async {
  //   // Upload the profile image in storage and return the image url
  //   String profileImageUrlTemp =
  //   await PersonalDetails.uploadProfileImageInStorage(
  //       userId: widget.userId, profileImage: profileImage!);
  //
  //   // Create the PersonalDetails class
  //   PersonalDetails personalDetails = PersonalDetails(
  //     userId: widget.userId,
  //     wantedJobTitle: wantedJobTitle!,
  //     profileImage: profileImage!,
  //     profileImageUrl: profileImageUrlTemp,
  //     firstName: firstName!,
  //     lastName: lastName!,
  //     dateOfBirth: dateOfBirth!,
  //     email: email!,
  //     phone: phone!,
  //     country: country!,
  //     city: city!,
  //     address: address!,
  //     postalCode: postalCode!,
  //   );
  //
  //   // Check if userId's document exists, if no, create one
  //   bool docExists = await FirebaseHelper.checkDocumentExists(
  //       collectionName: 'cv_professional_summary', docID: widget.userId);
  //   if (!docExists) {
  //     PersonalDetails.createPersonalDetailsInFirestore(userId: widget.userId);
  //   }
  //
  //   // Update in firestore
  //   personalDetails.updatePersonalDetailsToFirestore();
  //
  //   // Update the var userPersonalDetails
  //   userPersonalDetails = personalDetails;
  // }

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
          preferredMinSalary = leftValueTemp;
          preferredMaxSalary = rightValueTemp;
        });
      },
      smallerText: false,
    );
  }

  @override
  Widget build(BuildContext context) {
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
              Column(
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
                    padding:
                        EdgeInsets.only(left: 1.h, right: 1.h, bottom: 1.h),
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
                        ResumeBuilderPicker(
                          onPressed: () {
                            showEmpTypePicker();
                          },
                          title: 'Preferred Employment Type',
                          bodyText: preferredEmploymentType == null
                              ? Text(
                                  'Select your employment type',
                                  style: TextStyle(
                                    fontSize: 9.5.sp,
                                    color: Colors.grey.shade400,
                                  ),
                                )
                              : Text(
                                  preferredEmploymentType!,
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: const Color(0xFF1F1F39),
                                  ),
                                ),
                          disableBorder: false,
                        ),
                        seg,
                        ResumeBuilderPicker(
                          onPressed: () {
                            showJobTitlePicker();
                          },
                          title: 'Preferred Job Category & Title',
                          bodyText: preferredJobCategory == null &&
                                  preferredJobTitle == null
                              ? Text(
                                  'Select your preferred category & job title',
                                  style: TextStyle(
                                    fontSize: 9.5.sp,
                                    color: Colors.grey.shade400,
                                  ),
                                )
                              : Text(
                                  "${preferredJobCategory!} , ${preferredJobTitle!}",
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: const Color(0xFF1F1F39),
                                  ),
                                ),
                          disableBorder: false,
                        ),
                        seg,
                        ResumeBuilderPicker(
                          onPressed: () {
                            showCityStatePicker();
                          },
                          title: 'Preferred Job State & City',
                          bodyText:
                              preferredState == null && preferredCity == null
                                  ? Text(
                                      'Select your job state & city',
                                      style: TextStyle(
                                        fontSize: 9.5.sp,
                                        color: Colors.grey.shade400,
                                      ),
                                    )
                                  : Text(
                                      "${preferredState!} , ${preferredCity!}",
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        color: const Color(0xFF1F1F39),
                                      ),
                                    ),
                          disableBorder: false,
                        ),
                        seg,
                        ResumeBuilderPicker(
                          onPressed: () {
                            showSalaryRangePicker();
                          },
                          title: 'Preferred Salary',
                          bodyText: preferredMinSalary == null &&
                                  preferredMaxSalary == null
                              ? Text(
                                  'Select your preferred monthly salary range',
                                  style: TextStyle(
                                    fontSize: 9.5.sp,
                                    color: Colors.grey.shade400,
                                  ),
                                )
                              : Text(
                                  preferredMaxSalary!.isEmpty
                                      ? preferredMinSalary!
                                      : "${preferredMinSalary!} - ${preferredMaxSalary!}",
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: const Color(0xFF1F1F39),
                                  ),
                                ),
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
              child: ResumeBuilderButton(
                onPressed: isSaving ? null : saveButtonOnPressed,
                isHollow: false,
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
