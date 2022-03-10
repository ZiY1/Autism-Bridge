import 'package:autism_bridge/models/asd_user_credentials.dart';
import 'package:autism_bridge/models/job_preference_data.dart';
import 'package:autism_bridge/models/job_preference_picker_list.dart';
import 'package:autism_bridge/models/personal_details_data.dart';
import 'package:autism_bridge/models/recruiter_profile.dart';
import 'package:autism_bridge/models/recruiter_user_credentials.dart';
import 'package:autism_bridge/models/resume_data.dart';
import 'package:autism_bridge/screens/asd_job_preference_screen.dart';
import 'package:autism_bridge/screens/recruiter_home_screen.dart';
import 'package:autism_bridge/widgets/my_card_widget.dart';
import 'package:autism_bridge/widgets/my_gradient_container.dart';
import 'package:autism_bridge/widgets/resume_builder_button.dart';
import 'package:autism_bridge/widgets/resume_builder_input_field.dart';
import 'package:autism_bridge/widgets/resume_builder_picker.dart';
import 'package:autism_bridge/widgets/rounded_icon_container.dart';
import 'package:autism_bridge/widgets/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:autism_bridge/modified_flutter_packages/picker_from_pack.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../constants.dart';
import '../firebase_helpers.dart';

class RecruiterProfileScreen extends StatefulWidget {
  static const id = 'asd_personal_details_screen';

  final RecruiterUserCredentials recruiterUserCredentials;

  final RecruiterProfile recruiterProfile;

  const RecruiterProfileScreen({
    Key? key,
    required this.recruiterUserCredentials,
    required this.recruiterProfile,
  }) : super(key: key);

  @override
  State<RecruiterProfileScreen> createState() => _RecruiterProfileScreenState();
}

class _RecruiterProfileScreenState extends State<RecruiterProfileScreen> {
  bool isSaving = false;

  // DateTime selectedDate = DateTime.now();
  //
  // DateTime selectedDateTemp = DateTime.now();

  final Widget seg = SizedBox(height: 1.h);

  @override
  void initState() {
    super.initState();

    // PersonalDetails? personalDetailsTemp =
    //     widget.userResume.userPersonalDetails;
    // if (personalDetailsTemp != null) {
    //   userPersonalDetails = personalDetailsTemp;
    //   profileImage = personalDetailsTemp.profileImage;
    //   profileImageUrl = personalDetailsTemp.profileImageUrl;
    //   firstName = personalDetailsTemp.firstName;
    //   lastName = personalDetailsTemp.lastName;
    //   dateOfBirth = personalDetailsTemp.dateOfBirth;
    //   email = personalDetailsTemp.email;
    //   phone = personalDetailsTemp.phone;
    //   state = personalDetailsTemp.state;
    //   city = personalDetailsTemp.city;
    //   address = personalDetailsTemp.address;
    //   postalCode = personalDetailsTemp.postalCode;
    //
    //   selectedDate = DateFormat('MM/dd/yyyy').parse(dateOfBirth!);
    // }
  }

  Future<void> saveButtonOnPressed() async {
    // Ensure all fields are not null
    if (widget.recruiterProfile.profileImage == null) {
      Utils.showSnackBar(
        'Please upload your profile photo',
        const Icon(
          Icons.error_sharp,
          color: Colors.red,
          size: 30.0,
        ),
      );
      return;
    }
    if (widget.recruiterProfile.firstName == null ||
        widget.recruiterProfile.firstName!.isEmpty) {
      Utils.showSnackBar(
        'Please enter your first name',
        const Icon(
          Icons.error_sharp,
          color: Colors.red,
          size: 30.0,
        ),
      );
      return;
    }

    if (widget.recruiterProfile.lastName == null ||
        widget.recruiterProfile.lastName!.isEmpty) {
      Utils.showSnackBar(
        'Please enter your last name',
        const Icon(
          Icons.error_sharp,
          color: Colors.red,
          size: 30.0,
        ),
      );
      return;
    }

    if (widget.recruiterProfile.companyName == null ||
        widget.recruiterProfile.companyName!.isEmpty) {
      Utils.showSnackBar(
        'Please enter your company name',
        const Icon(
          Icons.error_sharp,
          color: Colors.red,
          size: 30.0,
        ),
      );
      return;
    }

    if (widget.recruiterProfile.jobTitle == null ||
        widget.recruiterProfile.jobTitle!.isEmpty) {
      Utils.showSnackBar(
        'Please enter your job title',
        const Icon(
          Icons.error_sharp,
          color: Colors.red,
          size: 30.0,
        ),
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

    if (widget.recruiterUserCredentials.isFirstTimeIn) {
      // List<JobPreference?> userJobPreferenceList = [];
      // widget.userResume.setPersonalDetails = userPersonalDetails;
      // Resume resumeTemp = await Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => AsdJobPreferenceScreen(
      //       asdUserCredentials: widget.asdUserCredentials,
      //       userResume: widget.userResume,
      //       isAddingNew: true,
      //       userJobPreferenceList: userJobPreferenceList,
      //       isFirstTimeIn: true,
      //     ),
      //   ),
      // );
      //
      // setState(() {
      //   widget.userResume.setPersonalDetails = resumeTemp.userPersonalDetails;
      //   userPersonalDetails = widget.userResume.userPersonalDetails;
      // });
      // Update isFirstTimeIn to false in all_users collection
      await FirebaseFirestore.instance
          .collection('all_users')
          .doc(widget.recruiterProfile.userId)
          .update({
        'isFirstTimeIn': false,
      });

      // Update isFirstTimeIn to false in job_seeker_users collection
      await FirebaseFirestore.instance
          .collection('recruiter_users')
          .doc(widget.recruiterProfile.userId)
          .update({
        'isFirstTimeIn': false,
      });

      // Update the userCredential class
      widget.recruiterUserCredentials.setIsFirstTimeIn = false;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => RecruiterHomeScreen(
            recruiterUserCredentials: widget.recruiterUserCredentials,
          ),
        ),
        (route) => false,
      );
    } else {
      Navigator.pop(context, widget.recruiterProfile);
    }
  }

  Future<void> handleDataInFirebase() async {
    // Upload the profile image in storage and return the image url
    String profileImageUrlTemp =
        await PersonalDetails.uploadProfileImageInStorage(
            userId: widget.recruiterUserCredentials.userId,
            profileImage: widget.recruiterProfile.profileImage!);

    widget.recruiterProfile.setProfileImageUrl = profileImageUrlTemp;

    // Create the RecruiterProfile class
    RecruiterProfile recruiterProfile = RecruiterProfile(
      userId: widget.recruiterUserCredentials.userId,
      profileImage: widget.recruiterProfile.profileImage!,
      profileImageUrl: widget.recruiterProfile.profileImageUrl!,
      firstName: widget.recruiterProfile.firstName!,
      lastName: widget.recruiterProfile.lastName!,
      companyName: widget.recruiterProfile.companyName!,
      jobTitle: widget.recruiterProfile.jobTitle!,
    );

    // Check if userId's document exists, if no, create one
    bool docExists = await FirebaseHelper.checkDocumentExists(
        collectionName: 'recruiter_profile',
        docID: widget.recruiterUserCredentials.userId);
    if (!docExists) {
      RecruiterProfile.createRecruiterProfileInFirestore(
        userId: widget.recruiterUserCredentials.userId,
      );
    }

    // Update in firestore
    await recruiterProfile.updateRecruiterProfileToFirestore();
  }

  Future<ImageSource?> showImageSource() async {
    return showModalBottomSheet(
      backgroundColor: kBackgroundRiceWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
      ),
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text("Camera"),
            onTap: () => Navigator.of(context).pop(
              ImageSource.camera,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text("Gallery"),
            onTap: () => Navigator.of(context).pop(
              ImageSource.gallery,
            ),
          ),
        ],
      ),
    );
  }

  Future pickImage(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() {
        widget.recruiterProfile.setProfileImage = imageTemp;
      });
    } on PlatformException catch (e) {
      Utils.showSnackBar(
        e.message,
        const Icon(
          Icons.error_sharp,
          color: Colors.red,
          size: 30.0,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyGradientContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: widget.recruiterUserCredentials.isFirstTimeIn
            ? null
            : AppBar(
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                title: const Text(
                  'My Profile',
                  style: TextStyle(
                    color: kTitleBlack,
                  ),
                ),
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
              widget.recruiterUserCredentials.isFirstTimeIn
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 1.h, vertical: 1.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'My Business Card',
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
                                      text: '1',
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
                            'Start recruiting by adding your business card',
                            style: TextStyle(
                              color: kRegistrationSubtitleGrey,
                              fontSize: 9.5.sp,
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
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
                        Padding(
                          padding: EdgeInsets.only(left: 1.85.h, bottom: 0.3.h),
                          child: Text(
                            'Profile Picture',
                            style: TextStyle(
                              color: const Color(0xFF858597),
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 0.4.h,
                            left: 1.65.h,
                            right: 1.65.h,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                radius: 31,
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(100.0), //or 15.0
                                  child: Container(
                                    height: double.infinity,
                                    width: double.infinity,
                                    color: kBackgroundRiceWhite,
                                    child:
                                        widget.recruiterProfile.profileImage !=
                                                null
                                            ? FittedBox(
                                                child: Image.file(widget
                                                    .recruiterProfile
                                                    .profileImage!),
                                                fit: BoxFit.fill,
                                              )
                                            : const Icon(
                                                CupertinoIcons.person_alt,
                                                color: Color(0xFFBEC4D5),
                                                size: 32.0,
                                              ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 1.h,
                              ),
                              InkWell(
                                onTap: () async {
                                  final source = await showImageSource();
                                  if (source == null) return;
                                  pickImage(source);
                                },
                                child: Text(
                                  'Upload photo',
                                  style: TextStyle(
                                    color: kAutismBridgeBlue,
                                    fontSize: 9.5.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        seg,
                      ],
                    ),
                  ),
                ),
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
                      children: [
                        seg,
                        ResumeBuilderInputField(
                            onChanged: (text) {
                              widget.recruiterProfile.setFirstName = text;
                            },
                            initialValue: widget.recruiterProfile.firstName,
                            title: 'First Name',
                            hintText: 'Enter your first name',
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next),
                        seg,
                        ResumeBuilderInputField(
                          onChanged: (text) {
                            widget.recruiterProfile.setLastName = text;
                          },
                          initialValue: widget.recruiterProfile.lastName,
                          title: 'Last Name',
                          hintText: 'Enter your last name',
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          disableBorder: true,
                        ),
                      ],
                    ),
                  ),
                ),
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
                      children: [
                        seg,
                        ResumeBuilderInputField(
                          onChanged: (text) {
                            widget.recruiterProfile.setCompanyName = text;
                          },
                          initialValue: widget.recruiterProfile.companyName,
                          title: 'Company',
                          hintText: 'Enter your company name',
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                        ),
                        seg,
                        ResumeBuilderInputField(
                          onChanged: (text) {
                            widget.recruiterProfile.setJobTitle = text;
                          },
                          initialValue: widget.recruiterProfile.jobTitle,
                          title: 'Job Title',
                          hintText: 'Enter your job title',
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
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
                        widget.recruiterUserCredentials.isFirstTimeIn
                            ? 'Save & Next'
                            : 'Save',
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
