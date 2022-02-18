import 'package:autism_bridge/models/personal_details_data.dart';
import 'package:autism_bridge/widgets/resume_builder_button.dart';
import 'package:autism_bridge/widgets/resume_builder_input_field.dart';
import 'package:autism_bridge/widgets/resume_builder_picker.dart';
import 'package:autism_bridge/widgets/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../constants.dart';
import '../firebase_helpers.dart';

class AsdPersonalDetailsScreen extends StatefulWidget {
  static const id = 'asd_personal_details_screen';

  final String userFirstName;

  final String userLastName;

  final String userEmail;

  final String userId;

  final PersonalDetails? userPersonalDetails;

  const AsdPersonalDetailsScreen(
      {Key? key,
      required this.userFirstName,
      required this.userLastName,
      required this.userEmail,
      required this.userId,
      required this.userPersonalDetails})
      : super(key: key);

  @override
  State<AsdPersonalDetailsScreen> createState() =>
      _AsdPersonalDetailsScreenState();
}

class _AsdPersonalDetailsScreenState extends State<AsdPersonalDetailsScreen> {
  PersonalDetails? userPersonalDetails;

  String? wantedJobTitle;

  File? profileImage;

  String? profileImageUrl;

  String? firstName;

  String? lastName;

  String? dateOfBirth;

  String? email;

  String? phone;

  String? country;

  String? city;

  String? address;

  String? postalCode;

  bool isSaving = false;

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    PersonalDetails? personalDetailsTemp = widget.userPersonalDetails;
    if (personalDetailsTemp != null) {
      userPersonalDetails = personalDetailsTemp;
      wantedJobTitle = personalDetailsTemp.wantedJobTitle;
      profileImage = personalDetailsTemp.profileImage;
      profileImageUrl = personalDetailsTemp.profileImageUrl;
      firstName = personalDetailsTemp.firstName;
      lastName = personalDetailsTemp.lastName;
      dateOfBirth = personalDetailsTemp.dateOfBirth;
      email = personalDetailsTemp.email;
      phone = personalDetailsTemp.phone;
      country = personalDetailsTemp.country;
      city = personalDetailsTemp.city;
      address = personalDetailsTemp.address;
      postalCode = personalDetailsTemp.postalCode;

      selectedDate = DateFormat('MM/dd/yyyy').parse(dateOfBirth!);
    }
  }

  Future<void> saveButtonOnPressed() async {
    // Ensure all fields are not null
    if (wantedJobTitle == null || wantedJobTitle!.isEmpty) {
      Utils.showSnackBar(
        'Please enter your wanted job title',
        const Icon(
          Icons.error_sharp,
          color: Colors.red,
          size: 30.0,
        ),
      );
      return;
    }
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
    if (country == null || country!.isEmpty) {
      Utils.showSnackBar(
        'Please enter your country',
        const Icon(
          Icons.error_sharp,
          color: Colors.red,
          size: 30.0,
        ),
      );
      return;
    }
    if (city == null || city!.isEmpty) {
      Utils.showSnackBar(
        'Please enter your city',
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

    Navigator.pop(context, userPersonalDetails);

    // save it to firebase
  }

  Future<void> handleDataInFirebase() async {
    // Upload the profile image in storage and return the image url
    String profileImageUrlTemp =
        await PersonalDetails.uploadProfileImageInStorage(
            userId: widget.userId, profileImage: profileImage!);

    // Create the PersonalDetails class
    PersonalDetails personalDetails = PersonalDetails(
      userId: widget.userId,
      wantedJobTitle: wantedJobTitle!,
      profileImage: profileImage!,
      profileImageUrl: profileImageUrlTemp,
      firstName: firstName!,
      lastName: lastName!,
      dateOfBirth: dateOfBirth!,
      email: email!,
      phone: phone!,
      country: country!,
      city: city!,
      address: address!,
      postalCode: postalCode!,
    );

    // Check if userId's document exists, if no, create one
    bool docExists = await FirebaseHelper.checkDocumentExists(
        collectionName: 'cv_professional_summary', docID: widget.userId);
    if (!docExists) {
      PersonalDetails.createPersonalDetailsInFirestore(userId: widget.userId);
    }

    // Update in firestore
    personalDetails.updatePersonalDetailsToFirestore();

    // Update the var userPersonalDetails
    userPersonalDetails = personalDetails;
  }

  Future<ImageSource?> showImageSource() async {
    if (Platform.isIOS) {
      return showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () => Navigator.of(context).pop(ImageSource.camera),
              child: const Text('Camera'),
            ),
            CupertinoActionSheetAction(
              onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
              child: const Text('Gallery'),
            ),
          ],
        ),
      );
    } else {
      return showModalBottomSheet(
        backgroundColor: const Color(0xFFF0F0F2),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.0),
            topRight: Radius.circular(8.0),
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
  }

  // TODO: configure for iOS
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
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: double.infinity,
                color: kCupertinoPickerTopBarWhite,
                child: CupertinoButton(
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Done',
                    ),
                  ),
                  onPressed: () {
                    setState(() {});
                    Navigator.pop(context);
                  },
                ),
                height: MediaQuery.of(context).copyWith().size.height * 0.06,
              ),
              Container(
                height: MediaQuery.of(context).copyWith().size.height * 0.30,
                color: kCupertinoPickerBackgroundGrey,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (dateValue) {
                    selectedDate = dateValue;
                    dateOfBirth = DateFormat('MM/dd/yyyy').format(dateValue);
                  },
                  initialDateTime: selectedDate,
                  minimumYear: 1900,
                  maximumYear: DateTime.now().year,
                  // maximumDate: DateTime.now(),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundRiceWhite,
      appBar: AppBar(
        elevation: 0.5,
        //backgroundColor: kBackgroundRiceWhite,
        backgroundColor: kAutismBridgeBlue,
        title: const Text('Personal Details'),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: 0.5.h,
            vertical: 2.5.h,
          ),
          children: [
            Row(
              children: [
                Expanded(
                  child: ResumeBuilderInputField(
                      onChanged: (text) {
                        wantedJobTitle = text;
                      },
                      initialValue: wantedJobTitle,
                      title: 'Wanted Job Title',
                      hintText: 'e.g. Teacher',
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 0.4.h,
                      left: 1.65.h,
                      right: 1.65.h,
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5.0), //or 15.0
                          child: Container(
                            height: 8.h,
                            width: 8.h,
                            color: Colors.white,
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
                ),
              ],
            ),
            SizedBox(
              height: 1.5.h,
            ),
            Row(
              children: [
                Expanded(
                  child: ResumeBuilderInputField(
                      onChanged: (text) {
                        firstName = text;
                      },
                      initialValue: firstName,
                      title: 'First Name',
                      hintText: 'Enter your first name',
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next),
                ),
                Expanded(
                  child: ResumeBuilderInputField(
                      onChanged: (text) {
                        lastName = text;
                      },
                      initialValue: lastName,
                      title: 'Last Name',
                      hintText: 'Enter your last name',
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next),
                ),
              ],
            ),
            SizedBox(
              height: 1.5.h,
            ),
            ResumeBuilderPicker(
              title: 'Date Of Birth',
              bodyText: dateOfBirth != null
                  ? Text(
                      dateOfBirth!,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: const Color(0xFF1F1F39),
                      ),
                    )
                  : Text(
                      'DD/MM/YYYY',
                      style: TextStyle(
                        fontSize: 9.5.sp,
                        color: Colors.grey.shade400,
                      ),
                    ),
              onPressed: () {
                dateOfBirth = DateFormat('MM/dd/yyyy').format(selectedDate);
                return showDatePicker();
              },
            ),
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
            SizedBox(
              height: 1.5.h,
            ),
            ResumeBuilderInputField(
              onChanged: (text) {
                phone = text;
              },
              initialValue: phone,
              title: 'Phone',
              hintText: 'Enter your phone number',
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(
              height: 1.5.h,
            ),
            ResumeBuilderInputField(
              onChanged: (text) {
                country = text;
              },
              initialValue: country,
              title: 'Country',
              hintText: 'Enter your country',
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(
              height: 1.5.h,
            ),
            ResumeBuilderInputField(
              onChanged: (text) {
                city = text;
              },
              initialValue: city,
              title: 'City',
              hintText: 'Enter your city',
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(
              height: 1.5.h,
            ),
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
            SizedBox(
              height: 1.5.h,
            ),
            ResumeBuilderInputField(
              onChanged: (text) {
                postalCode = text;
              },
              initialValue: postalCode,
              title: 'Postal Code',
              hintText: 'Enter your postal code',
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
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
    );
  }
}
