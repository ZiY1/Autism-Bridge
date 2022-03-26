import 'package:autism_bridge/models/asd_user_credentials.dart';
import 'package:autism_bridge/models/job_preference_data.dart';
import 'package:autism_bridge/models/job_matching_picker_list.dart';
import 'package:autism_bridge/models/personal_details_data.dart';
import 'package:autism_bridge/models/resume_data.dart';
import 'package:autism_bridge/screens/asd_job_preference_screen.dart';
import 'package:autism_bridge/widgets/my_card_widget.dart';
import 'package:autism_bridge/widgets/my_gradient_container.dart';
import 'package:autism_bridge/widgets/resume_builder_button.dart';
import 'package:autism_bridge/widgets/resume_builder_input_field.dart';
import 'package:autism_bridge/widgets/input_holder.dart';
import 'package:autism_bridge/widgets/rounded_icon_container.dart';
import 'package:autism_bridge/widgets/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:autism_bridge/modified_flutter_packages/picker_from_pack.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../color_constants.dart';
import '../firebase_helpers.dart';

class AsdPersonalDetailsScreen extends StatefulWidget {
  static const id = 'asd_personal_details_screen';

  final AsdUserCredentials asdUserCredentials;

  final Resume userResume;

  final bool isFirstTimeIn;

  const AsdPersonalDetailsScreen({
    Key? key,
    required this.asdUserCredentials,
    required this.userResume,
    required this.isFirstTimeIn,
  }) : super(key: key);

  @override
  State<AsdPersonalDetailsScreen> createState() =>
      _AsdPersonalDetailsScreenState();
}

class _AsdPersonalDetailsScreenState extends State<AsdPersonalDetailsScreen> {
  PersonalDetails? userPersonalDetails;

  File? profileImage;

  String? profileImageUrl;

  String? firstName;

  String? lastName;

  String? dateOfBirth;

  String? dateOfBirthTemp;

  String? email;

  String? phone;

  String? state;

  String? city;

  String? address;

  String? postalCode;

  bool isSaving = false;

  DateTime selectedDate = DateTime.now();

  DateTime selectedDateTemp = DateTime.now();

  final Widget seg = SizedBox(height: 1.h);

  @override
  void initState() {
    super.initState();

    PersonalDetails? personalDetailsTemp =
        widget.userResume.userPersonalDetails;
    if (personalDetailsTemp != null) {
      userPersonalDetails = personalDetailsTemp;
      profileImage = personalDetailsTemp.profileImage;
      profileImageUrl = personalDetailsTemp.profileImageUrl;
      firstName = personalDetailsTemp.firstName;
      lastName = personalDetailsTemp.lastName;
      dateOfBirth = personalDetailsTemp.dateOfBirth;
      email = personalDetailsTemp.email;
      phone = personalDetailsTemp.phone;
      state = personalDetailsTemp.state;
      city = personalDetailsTemp.city;
      address = personalDetailsTemp.address;
      postalCode = personalDetailsTemp.postalCode;

      selectedDate = DateFormat('MM/dd/yyyy').parse(dateOfBirth!);
    }
  }

  Future<void> saveButtonOnPressed() async {
    // Ensure all fields are not null
    if (profileImage == null) {
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
    if (firstName == null || firstName!.isEmpty) {
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

    if (lastName == null || lastName!.isEmpty) {
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
    if (dateOfBirth == null || dateOfBirth!.isEmpty) {
      Utils.showSnackBar(
        'Please enter your date of birth',
        const Icon(
          Icons.error_sharp,
          color: Colors.red,
          size: 30.0,
        ),
      );
      return;
    }
    if (email == null || email!.isEmpty) {
      Utils.showSnackBar(
        'Please enter your email',
        const Icon(
          Icons.error_sharp,
          color: Colors.red,
          size: 30.0,
        ),
      );
      return;
    }
    if (phone == null || phone!.isEmpty) {
      Utils.showSnackBar(
        'Please enter your phone number',
        const Icon(
          Icons.error_sharp,
          color: Colors.red,
          size: 30.0,
        ),
      );
      return;
    }
    if (city == null || city!.isEmpty || state == null || state!.isEmpty) {
      Utils.showSnackBar(
        'Please select your living city',
        const Icon(
          Icons.error_sharp,
          color: Colors.red,
          size: 30.0,
        ),
      );
      return;
    }
    if (address == null || address!.isEmpty) {
      Utils.showSnackBar(
        'Please enter your address',
        const Icon(
          Icons.error_sharp,
          color: Colors.red,
          size: 30.0,
        ),
      );
      return;
    }
    if (postalCode == null || postalCode!.isEmpty) {
      Utils.showSnackBar(
        'Please enter your postal code',
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

    if (widget.isFirstTimeIn) {
      List<JobPreference?> userJobPreferenceList = [];
      widget.userResume.setPersonalDetails = userPersonalDetails;
      Resume resumeTemp = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AsdJobPreferenceScreen(
            asdUserCredentials: widget.asdUserCredentials,
            userResume: widget.userResume,
            isAddingNew: true,
            userJobPreferenceList: userJobPreferenceList,
            isFirstTimeIn: true,
          ),
        ),
      );

      setState(() {
        widget.userResume.setPersonalDetails = resumeTemp.userPersonalDetails;
        userPersonalDetails = widget.userResume.userPersonalDetails;
      });
    } else {
      Navigator.pop(context, userPersonalDetails);
    }
  }

  Future<void> handleDataInFirebase() async {
    // Upload the profile image in storage and return the image url
    String profileImageUrlTemp =
        await PersonalDetails.uploadProfileImageInStorage(
            userId: widget.asdUserCredentials.userId,
            profileImage: profileImage!);

    // Create the PersonalDetails class
    PersonalDetails personalDetails = PersonalDetails(
      userId: widget.asdUserCredentials.userId,
      profileImage: profileImage!,
      profileImageUrl: profileImageUrlTemp,
      firstName: firstName!,
      lastName: lastName!,
      dateOfBirth: dateOfBirth!,
      email: email!,
      phone: phone!,
      state: state!,
      city: city!,
      address: address!,
      postalCode: postalCode!,
    );

    // Check if userId's document exists, if no, create one
    bool docExists = await FirebaseHelper.checkDocumentExists(
        collectionName: 'cv_personal_details',
        docID: widget.asdUserCredentials.userId);
    if (!docExists) {
      await PersonalDetails.createPersonalDetailsInFirestore(
          userId: widget.asdUserCredentials.userId);
    }

    // Update in firestore
    await personalDetails.updatePersonalDetailsToFirestore();

    // Update the var userPersonalDetails
    userPersonalDetails = personalDetails;
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

    // As a reference:
    // if (Platform.isIOS) {
    //   return showCupertinoModalPopup(
    //     context: context,
    //     builder: (context) => CupertinoActionSheet(
    //       actions: [
    //         CupertinoActionSheetAction(
    //           onPressed: () => Navigator.of(context).pop(ImageSource.camera),
    //           child: const Text('Camera'),
    //         ),
    //         CupertinoActionSheetAction(
    //           onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
    //           child: const Text('Gallery'),
    //         ),
    //       ],
    //     ),
    //   );
    // }
  }

  Future pickImage(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() {
        profileImage = imageTemp;
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

  void showDatePicker() {
    Utils.showMyDatePicker(
      context: context,
      child: Container(
        height: MediaQuery.of(context).copyWith().size.height * 0.30,
        color: kBackgroundRiceWhite,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (dateValue) {
            selectedDateTemp = dateValue;
            dateOfBirthTemp = DateFormat('MM/dd/yyyy').format(dateValue);
          },
          initialDateTime: selectedDate,
          minimumYear: 1900,
          maximumYear: DateTime.now().year,
          // maximumDate: DateTime.now(),
        ),
      ),
      onCancel: () {
        Navigator.pop(context);
      },
      onConfirm: () {
        setState(() {
          selectedDate = selectedDateTemp;
          dateOfBirth = dateOfBirthTemp;
        });
        Navigator.pop(context);
      },
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
          state = leftValueTemp;
          city = rightValueTemp;
        });
      },
      smallerText: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MyGradientContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: widget.isFirstTimeIn
            ? null
            : AppBar(
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                title: const Text(
                  'Personal Details',
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
              widget.isFirstTimeIn
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
                                'My Profile',
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
                            'Start creating connection with recruiters by adding your profile',
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
                                    child: profileImage != null
                                        ? FittedBox(
                                            child: Image.file(profileImage!),
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
                              firstName = text;
                            },
                            initialValue: firstName,
                            title: 'First Name',
                            hintText: 'Enter your first name',
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next),
                        seg,
                        ResumeBuilderInputField(
                            onChanged: (text) {
                              lastName = text;
                            },
                            initialValue: lastName,
                            title: 'Last Name',
                            hintText: 'Enter your last name',
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next),
                        seg,
                        InputHolder(
                          title: 'Date Of Birth',
                          bodyText: dateOfBirth,
                          hintText: 'Select your date of birth',
                          onPressed: () {
                            dateOfBirthTemp = DateFormat('MM/dd/yyyy')
                                .format(selectedDateTemp);
                            return showDatePicker();
                          },
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
                            email = text;
                          },
                          initialValue: email,
                          title: 'Email',
                          hintText: 'Enter your email',
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                        ),
                        seg,
                        ResumeBuilderInputField(
                          onChanged: (text) {
                            phone = text;
                          },
                          initialValue: phone,
                          title: 'Phone',
                          hintText: 'Enter your phone number',
                          keyboardType: TextInputType.phone,
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
                        InputHolder(
                          onPressed: () {
                            showCityStatePicker();
                          },
                          title: 'Current Living City & State',
                          bodyText: state == null && city == null
                              ? null
                              : '${city!} , ${state!}',
                          hintText: 'Select your living state & city',
                          disableBorder: false,
                        ),
                        seg,
                        ResumeBuilderInputField(
                          onChanged: (text) {
                            address = text;
                          },
                          initialValue: address,
                          title: 'Address',
                          hintText: 'Enter your address',
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                        ),
                        seg,
                        ResumeBuilderInputField(
                          onChanged: (text) {
                            postalCode = text;
                          },
                          initialValue: postalCode,
                          title: 'Postal Code',
                          hintText: 'Enter your postal code',
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
                        widget.isFirstTimeIn ? 'Save & Next' : 'Save',
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
