import 'package:autism_bridge/constants.dart';
import 'package:autism_bridge/models/asd_user_credentials.dart';
import 'package:autism_bridge/models/education_data.dart';
import 'package:autism_bridge/models/job_preference_picker_list.dart';
import 'package:autism_bridge/models/resume_builder_picker_list.dart';
import 'package:autism_bridge/widgets/my_card_widget.dart';
import 'package:autism_bridge/widgets/my_gradient_container.dart';
import 'package:autism_bridge/widgets/resume_builder_button.dart';
import 'package:autism_bridge/widgets/resume_builder_input_field.dart';
import 'package:autism_bridge/widgets/resume_builder_paragraph_field.dart';
import 'package:autism_bridge/widgets/resume_builder_picker.dart';
import 'package:autism_bridge/widgets/resume_date_toggle.dart';
import 'package:autism_bridge/widgets/rounded_icon_container.dart';
import 'package:autism_bridge/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:autism_bridge/widgets/cupertino_picker_extended.dart'
    as cupertino_extended;

enum PickerPosition {
  left,
  right,
}

class AsdEducationScreen extends StatefulWidget {
  static const id = 'asd_education_screen';

  final AsdUserCredentials asdUserCredentials;

  final bool isAddingNew;

  final String? subCollectionId;

  final int? listIndex;

  final List<Education?> userEducationList;

  const AsdEducationScreen(
      {Key? key,
      required this.asdUserCredentials,
      required this.isAddingNew,
      this.subCollectionId,
      this.listIndex,
      required this.userEducationList})
      : super(key: key);

  @override
  _AsdEducationScreenState createState() => _AsdEducationScreenState();
}

class _AsdEducationScreenState extends State<AsdEducationScreen> {
  final ScrollController _scrollController = ScrollController();

  int textLen = 0;

  String? school;

  String? major;

  String? degree;

  String? startDate;

  String? startDateTemp;

  String? endDate;

  String? endDateTemp;

  String? state;

  String? city;

  String? description;

  List<Education?>? userEducationList;

  bool isDatePresent = false;

  DateTime leftSelectedDate = DateTime.now();

  DateTime leftSelectedDateTemp = DateTime.now();

  DateTime rightSelectedDate = DateTime.now();

  DateTime rightSelectedDateTemp = DateTime.now();

  String btnText = 'Add';

  bool isSaving = false;

  bool isDeleting = false;

  final Widget seg = SizedBox(height: 1.h);

  @override
  void initState() {
    super.initState();

    List<Education?> educationListTemp = widget.userEducationList;

    userEducationList = educationListTemp;

    if (!widget.isAddingNew) {
      btnText = 'Save';

      if (userEducationList![widget.listIndex!] != null) {
        Education? educationTemp = userEducationList![widget.listIndex!];

        school = educationTemp!.school;
        major = educationTemp.major;
        degree = educationTemp.degree;
        startDate = educationTemp.startDate;
        endDate = educationTemp.endDate;
        state = educationTemp.state;
        city = educationTemp.city;
        description = educationTemp.description;

        textLen = description!.length;

        leftSelectedDate = DateFormat('MM/yyyy').parse(startDate!);
        if (endDate == 'Present') {
          isDatePresent = true;
        } else {
          rightSelectedDate = DateFormat('MM/yyyy').parse(endDate!);
        }
      }
    }
  }

  Future<void> deleteBtnOnPressed(BuildContext context) async {
    bool wantDelete = await Utils.showMyDialog(context);

    if (wantDelete) {
      setState(() {
        isDeleting = true;
      });

      await Education.deleteEducationFromFirestore(
        userId: widget.asdUserCredentials.userId,
        mySubCollectionId: widget.subCollectionId!,
      );

      userEducationList!.removeAt(widget.listIndex!);

      setState(() {
        isDeleting = false;
      });

      Navigator.pop(context, userEducationList);
    }
  }

  Future<void> saveAddBtnOnPressed(BuildContext context) async {
    //Ensure all fields are not null
    if (school == null || school!.isEmpty) {
      Utils.showSnackBar(
        'Please enter your school',
        const Icon(
          Icons.error_sharp,
          color: Colors.red,
          size: 30.0,
        ),
      );
      return;
    }
    if (major == null || major!.isEmpty) {
      Utils.showSnackBar(
        'Please enter your major',
        const Icon(
          Icons.error_sharp,
          color: Colors.red,
          size: 30.0,
        ),
      );
      return;
    }
    if (degree == null || degree!.isEmpty) {
      Utils.showSnackBar(
        'Please select your degree',
        const Icon(
          Icons.error_sharp,
          color: Colors.red,
          size: 30.0,
        ),
      );
      return;
    }
    if (startDate == null || startDate!.isEmpty) {
      Utils.showSnackBar(
        'Please select your start date',
        const Icon(
          Icons.error_sharp,
          color: Colors.red,
          size: 30.0,
        ),
      );
      return;
    }
    if (endDate == null || endDate!.isEmpty) {
      Utils.showSnackBar(
        'Please select your end date',
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
        'Please enter your study city',
        const Icon(
          Icons.error_sharp,
          color: Colors.red,
          size: 30.0,
        ),
      );
      return;
    }
    description ??= '';

    setState(() {
      isSaving = true;
    });

    await handleDataInFirebase();

    setState(() {
      isSaving = false;
    });

    Navigator.pop(context, userEducationList);
  }

  Future<void> handleDataInFirebase() async {
    // Create the ProfessionalSummary class
    Education education;

    if (widget.isAddingNew) {
      // Add the data in firestore

      // When creating, we use timestamp as unique id
      education = Education(
        userId: widget.asdUserCredentials.userId,
        subCollectionId: DateTime.now().microsecondsSinceEpoch.toString(),
        school: school!,
        major: major!,
        degree: degree!,
        startDate: startDate!,
        endDate: endDate!,
        state: state!,
        city: city!,
        description: description!,
      );

      // Add in firestore
      await education.addEducationToFirestore();

      // Update the list userEmploymentHistoryList
      userEducationList!.add(education);
    } else {
      // Update the data (subcolectionId) in firestore
      // make sure subCollectionId is not null

      // When updating, we don't update the timestamp
      education = Education(
        userId: widget.asdUserCredentials.userId,
        subCollectionId: widget.subCollectionId!,
        school: school!,
        major: major!,
        degree: degree!,
        startDate: startDate!,
        endDate: endDate!,
        state: state!,
        city: city!,
        description: description!,
      );

      await education.updateEducationToFirestore();

      // Update the list userEmploymentHistoryList
      // Ensure listIndex is not null
      userEducationList![widget.listIndex!] = education;
    }
  }

  void showDatePicker(PickerPosition myPicker) {
    Utils.showMyDatePicker(
      context: context,
      child: Container(
        height: MediaQuery.of(context).copyWith().size.height * 0.30,
        color: kBackgroundRiceWhite,
        child: cupertino_extended.CupertinoDatePicker(
          mode: cupertino_extended.CupertinoDatePickerMode.date,
          onDateTimeChanged: (dateValue) {
            myPicker == PickerPosition.left
                ? startDateOnChanged(dateValue)
                : endDateOnChanged(dateValue);
          },
          initialDateTime: myPicker == PickerPosition.left
              ? leftSelectedDate
              : rightSelectedDate,
          minimumYear: 1950,
          maximumYear: 2040,
          // maximumDate: DateTime.now(),
        ),
      ),
      onCancel: () {
        Navigator.pop(context);
      },
      onConfirm: () {
        setState(() {
          if (myPicker == PickerPosition.left) {
            leftSelectedDate = leftSelectedDateTemp;
            startDate = startDateTemp;
          } else {
            rightSelectedDate = rightSelectedDateTemp;
            endDate = endDateTemp;
          }
        });
        Navigator.pop(context);
      },
    );
  }

  void showDegreePicker() {
    Utils.showMyCustomizedPicker(
      context: context,
      pickerData: degreeList,
      onConfirm: (Picker picker, List value) {
        String strTemp = picker.adapter.text;
        String strTempRemovedBracket = strTemp.substring(1, strTemp.length - 1);
        setState(() {
          degree = strTempRemovedBracket;
        });
      },
      smallerText: false,
    );
  }

  void startDateOnChanged(dateValue) {
    leftSelectedDateTemp = dateValue;
    startDateTemp = DateFormat('MM/yyyy').format(dateValue);
  }

  void endDateOnChanged(dateValue) {
    rightSelectedDateTemp = dateValue;
    endDateTemp = DateFormat('MM/yyyy').format(dateValue);
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
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: const Text(
            'Education',
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
                        ResumeBuilderInputField(
                          onChanged: (text) {
                            school = text;
                          },
                          initialValue: school,
                          title: 'School',
                          hintText: 'e.g. City College of New York',
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                        ),
                        seg,
                        ResumeBuilderInputField(
                          onChanged: (text) {
                            major = text;
                          },
                          initialValue: major,
                          title: 'Major',
                          hintText: 'e.g. Computer Science',
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                        ),
                        seg,
                        ResumeBuilderPicker(
                          onPressed: () {
                            showDegreePicker();
                          },
                          title: 'Degree',
                          bodyText: degree == null
                              ? Text(
                                  'Select your degree',
                                  style: TextStyle(
                                    fontSize: 9.5.sp,
                                    color: Colors.grey.shade400,
                                  ),
                                )
                              : Text(
                                  degree!,
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
                        Row(
                          children: [
                            Expanded(
                              child: ResumeBuilderPicker(
                                onPressed: () {
                                  startDateTemp = DateFormat('MM/yyyy')
                                      .format(leftSelectedDateTemp);
                                  return showDatePicker(PickerPosition.left);
                                },
                                title: 'Start Date',
                                bodyText: startDate == null
                                    ? Text(
                                        'MM/YYYY',
                                        style: TextStyle(
                                          fontSize: 9.5.sp,
                                          color: Colors.grey.shade400,
                                        ),
                                      )
                                    : Text(
                                        startDate!,
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          color: const Color(0xFF1F1F39),
                                        ),
                                      ),
                                disableBorder: false,
                              ),
                            ),
                            Expanded(
                              child: ResumeBuilderPicker(
                                onPressed: () {
                                  if (isDatePresent) {
                                    return;
                                  } else {
                                    endDateTemp = DateFormat('MM/yyyy')
                                        .format(rightSelectedDateTemp);
                                    return showDatePicker(PickerPosition.right);
                                  }
                                },
                                title: 'End Date',
                                bodyText: endDate == null
                                    ? Text(
                                        'MM/YYYY',
                                        style: TextStyle(
                                          fontSize: 9.5.sp,
                                          color: Colors.grey.shade400,
                                        ),
                                      )
                                    : Text(
                                        endDate!,
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          color: const Color(0xFF1F1F39),
                                        ),
                                      ),
                                disableBorder: false,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 1.h),
                          child: ResumeDateToggle(
                            toggleText: 'Currently study here',
                            isDatePresent: isDatePresent,
                            onChanged: (value) {
                              setState(() {
                                isDatePresent = value;
                                if (value) {
                                  endDate = 'Present';
                                } else {
                                  endDate = null;
                                }
                              });
                            },
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
                            showCityStatePicker();
                          },
                          title: 'City & State',
                          bodyText: state == null && city == null
                              ? Text(
                                  'Select your work city & state',
                                  style: TextStyle(
                                    fontSize: 9.5.sp,
                                    color: Colors.grey.shade400,
                                  ),
                                )
                              : Text(
                                  "${city!} , ${state!}",
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
                          padding: EdgeInsets.symmetric(horizontal: 2.h),
                          child: ResumeBuilderParagraphField(
                              initialValue: description,
                              title: 'Description (optional)',
                              onChanged: (text) {
                                description = text;
                                setState(() {
                                  textLen = text.length;
                                });
                              },
                              autoFocus: false,
                              minLines: 5,
                              maxLines: 8,
                              hintText: 'e.g. Graduated with 3.9+ GPA',
                              scrollController: _scrollController,
                              textLen: textLen),
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
              child: widget.isAddingNew
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
