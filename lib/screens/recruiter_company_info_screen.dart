import 'package:autism_bridge/icon_constants.dart';
import 'package:autism_bridge/models/auto_complete_data_list.dart';
import 'package:autism_bridge/models/recruiter_company_info.dart';
import 'package:autism_bridge/models/recruiter_company_info_picker_list.dart';
import 'package:autism_bridge/models/recruiter_profile.dart';
import 'package:autism_bridge/models/recruiter_user_credentials.dart';
import 'package:autism_bridge/modified_flutter_packages/picker_from_pack.dart';
import 'package:autism_bridge/screens/recruiter_home_screen.dart';
import 'package:autism_bridge/screens/text_field_input_screen.dart';
import 'package:autism_bridge/widgets/my_card_widget.dart';
import 'package:autism_bridge/widgets/my_gradient_container.dart';
import 'package:autism_bridge/widgets/resume_builder_button.dart';
import 'package:autism_bridge/widgets/resume_builder_paragraph_field.dart';
import 'package:autism_bridge/widgets/input_holder.dart';
import 'package:autism_bridge/widgets/rounded_icon_container.dart';
import 'package:autism_bridge/widgets/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'dart:io';
import '../color_constants.dart';
import '../firebase_helpers.dart';

class RecruiterCompanyInfoScreen extends StatefulWidget {
  static const id = 'recruiter_company_info_screen';

  final RecruiterUserCredentials recruiterUserCredentials;

  final RecruiterProfile? recruiterProfile;

  final RecruiterCompanyInfo recruiterCompanyInfo;

  const RecruiterCompanyInfoScreen({
    Key? key,
    required this.recruiterUserCredentials,
    this.recruiterProfile,
    required this.recruiterCompanyInfo,
  }) : super(key: key);

  @override
  State<RecruiterCompanyInfoScreen> createState() =>
      _RecruiterCompanyInfoScreenState();
}

class _RecruiterCompanyInfoScreenState
    extends State<RecruiterCompanyInfoScreen> {
  final ScrollController _scrollController = ScrollController();

  int textLen = 0;

  bool isSaving = false;

  final Widget seg = SizedBox(height: 1.h);

  Future<void> saveButtonOnPressed() async {
    // Ensure all fields are not null
    if (widget.recruiterCompanyInfo.companyLogoImage == null) {
      Utils.showSnackBar(
        'Please upload your company logo',
        kErrorIcon,
      );
      return;
    }
    if (widget.recruiterCompanyInfo.companyName == null ||
        widget.recruiterCompanyInfo.companyName!.isEmpty) {
      Utils.showSnackBar(
        'Please enter your company name',
        kErrorIcon,
      );
      return;
    }

    if (widget.recruiterCompanyInfo.companyMinSize == null ||
        widget.recruiterCompanyInfo.companyMaxSize == null) {
      Utils.showSnackBar(
        'Please select your company size range',
        kErrorIcon,
      );
      return;
    }

    if (widget.recruiterCompanyInfo.companyAddress == null ||
        widget.recruiterCompanyInfo.companyAddress!.isEmpty) {
      Utils.showSnackBar(
        'Please enter your company address',
        kErrorIcon,
      );
      return;
    }

    // if (widget.recruiterCompanyInfo.companyDescription == null ||
    //     widget.recruiterCompanyInfo.companyDescription!.isEmpty) {
    //   Utils.showSnackBar(
    //     'Please enter your company description',
    //     kErrorIcon,
    //   );
    //   return;
    // }

    if (widget.recruiterCompanyInfo.companyDescription == null) {
      widget.recruiterCompanyInfo.setCompanyDescription = '';
    }

    setState(() {
      isSaving = true;
    });

    await handleDataInFirebase();

    setState(() {
      isSaving = false;
    });

    if (widget.recruiterUserCredentials.isFirstTimeIn) {
      try {
        // Update isFirstTimeIn to false in all_users collection
        await FirebaseFirestore.instance
            .collection('all_users')
            .doc(widget.recruiterUserCredentials.userId)
            .update({
          'isFirstTimeIn': false,
        });

        // Update isFirstTimeIn to false in job_seeker_users collection
        await FirebaseFirestore.instance
            .collection('recruiter_users')
            .doc(widget.recruiterUserCredentials.userId)
            .update({
          'isFirstTimeIn': false,
        });
      } on FirebaseException catch (e) {
        Utils.showSnackBar(
          e.message,
          kErrorIcon,
        );
        return;
      }

      // Update the userCredential class
      widget.recruiterUserCredentials.setIsFirstTimeIn = false;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => RecruiterHomeScreen(
            recruiterUserCredentials: widget.recruiterUserCredentials,
            recruiterProfile: widget.recruiterProfile!,
            recruiterCompanyInfo: widget.recruiterCompanyInfo,
          ),
        ),
        (route) => false,
      );
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> handleDataInFirebase() async {
    // Upload the company logo image in storage and return the image url
    String companyLogoImageUrl =
        await RecruiterCompanyInfo.uploadCompanyLogoImageInStorage(
            userId: widget.recruiterUserCredentials.userId,
            companyLogoImage: widget.recruiterCompanyInfo.companyLogoImage!);

    widget.recruiterCompanyInfo.setCompanyLogoImageUrl = companyLogoImageUrl;

    // Check if userId's document exists, if no, create one
    bool docExists = await FirebaseHelper.checkDocumentExists(
        collectionName: 'recruiter_company_info',
        docID: widget.recruiterUserCredentials.userId);
    if (!docExists) {
      try {
        await RecruiterCompanyInfo.createRecruiterCompanyInfoInFirestore(
          userId: widget.recruiterUserCredentials.userId,
        );
      } on FirebaseException catch (e) {
        Utils.showSnackBar(
          e.message,
          kErrorIcon,
        );
        return;
      }
    }

    // Update in firestore
    try {
      await widget.recruiterCompanyInfo.updateRecruiterCompanyInfoToFirestore();
    } on FirebaseException catch (e) {
      Utils.showSnackBar(
        e.message,
        kErrorIcon,
      );
      return;
    }
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
        widget.recruiterCompanyInfo.setCompanyLogoImage = imageTemp;
      });
    } on PlatformException catch (e) {
      Utils.showSnackBar(
        e.message,
        kErrorIcon,
      );
    }
  }

  void showCompanySizeRangePicker() {
    Utils.showMyCustomizedPicker(
      context: context,
      pickerData: companySizeRageList,
      onConfirm: (Picker picker, List value) {
        String strTemp = picker.adapter.text;
        String strTempRemovedBracket = strTemp.substring(1, strTemp.length - 1);

        List tempList = strTempRemovedBracket.split(',');
        String leftValueTemp = tempList[0];
        String rightValueTempWithWhiteSpace = tempList[1];
        String rightValueTemp = rightValueTempWithWhiteSpace.substring(
            1, rightValueTempWithWhiteSpace.length);
        setState(() {
          widget.recruiterCompanyInfo.setCompanyMinSize = leftValueTemp;
          widget.recruiterCompanyInfo.setCompanyMaxSize = rightValueTemp;
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
        appBar: widget.recruiterUserCredentials.isFirstTimeIn
            ? null
            : AppBar(
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                title: const Text(
                  'My Company Information',
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
                                'My Company Info',
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
                            'Start recruiting by adding your company information',
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
                            'Company Logo',
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
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(8.0), //or 15.0
                                child: Container(
                                  height: 8.h,
                                  width: 8.h,
                                  color: kBackgroundRiceWhite,
                                  child: widget.recruiterCompanyInfo
                                              .companyLogoImage !=
                                          null
                                      ? FittedBox(
                                          child: Image.file(widget
                                              .recruiterCompanyInfo
                                              .companyLogoImage!),
                                          fit: BoxFit.fill,
                                        )
                                      : const Icon(
                                          Icons.business,
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
                        InputHolder(
                          onPressed: () async {
                            widget.recruiterCompanyInfo.setCompanyName =
                                await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TextFieldInputScreen(
                                  title: 'Company Name',
                                  hintText: 'Enter your company name',
                                  userInput:
                                      widget.recruiterCompanyInfo.companyName,
                                  keyBoardType: TextInputType.text,
                                  autoCompleteList: employersList,
                                ),
                              ),
                            );
                            setState(() {});
                          },
                          title: 'Company Name',
                          bodyText: widget.recruiterCompanyInfo.companyName,
                          hintText: 'Enter your company name',
                          disableBorder: false,
                        ),
                        seg,
                        InputHolder(
                          onPressed: showCompanySizeRangePicker,
                          title: 'Company Size',
                          bodyText: widget
                                  .recruiterCompanyInfo.companyMaxSize!.isEmpty
                              ? widget.recruiterCompanyInfo.companyMinSize!
                              : '${widget.recruiterCompanyInfo.companyMinSize!} - ${widget.recruiterCompanyInfo.companyMaxSize!}',
                          hintText: 'Select your company size range',
                          disableBorder: false,
                        ),
                        seg,
                        //TODO: change it to google places autocomplete
                        InputHolder(
                          onPressed: () async {
                            widget.recruiterCompanyInfo.setCompanyAddress =
                                await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TextFieldInputScreen(
                                  title: 'Company Address',
                                  hintText: 'Enter your company address',
                                  userInput: widget
                                      .recruiterCompanyInfo.companyAddress,
                                  keyBoardType: TextInputType.text,
                                ),
                              ),
                            );
                            setState(() {});
                          },
                          title: 'Company Address',
                          bodyText: widget.recruiterCompanyInfo.companyAddress,
                          hintText: 'Enter your company address',
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
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.h),
                          child: ResumeBuilderParagraphField(
                            initialValue:
                                widget.recruiterCompanyInfo.companyDescription,
                            title: 'Company Description (optional)',
                            onChanged: (text) {
                              widget.recruiterCompanyInfo
                                  .setCompanyDescription = text;
                              setState(() {
                                textLen = text.length;
                              });
                            },
                            autoFocus: false,
                            minLines: 5,
                            maxLines: 8,
                            hintText: 'Describe your company',
                            scrollController: _scrollController,
                            textLen: textLen,
                          ),
                        ),
                        seg,
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
              child: widget.recruiterUserCredentials.isFirstTimeIn
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: MyBottomButton(
                            child: Text(
                              'Back',
                              style: TextStyle(
                                fontSize: 12.5.sp,
                                color: kAutismBridgeBlue,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context, widget.recruiterProfile);
                            },
                            isHollow: true,
                          ),
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        Expanded(
                          child: MyBottomButton(
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
                                    saveButtonOnPressed();
                                  },
                            isHollow: false,
                          ),
                        ),
                      ],
                    )
                  : MyBottomButton(
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
