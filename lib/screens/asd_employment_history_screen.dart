import 'package:autism_bridge/constants.dart';
import 'package:autism_bridge/models/employment_history_data.dart';
import 'package:autism_bridge/widgets/resume_builder_button.dart';
import 'package:autism_bridge/widgets/resume_builder_input_field.dart';
import 'package:autism_bridge/widgets/resume_builder_paragraph_field.dart';
import 'package:autism_bridge/widgets/resume_builder_picker.dart';
import 'package:autism_bridge/widgets/resume_date_toggle.dart';
import 'package:autism_bridge/widgets/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:autism_bridge/widgets/cupertino_picker_extended.dart'
    as CupertinoExtended;

enum Picker {
  left,
  right,
}

class AsdEmploymentHistoryScreen extends StatefulWidget {
  static const id = 'asd_employment_history_screen';

  final String userFirstName;

  final String userLastName;

  final String userEmail;

  final String userId;

  final bool isAddingNew;

  final String? subCollectionId;

  final int? listIndex;

  final List<EmploymentHistory?> userEmploymentHistoryList;

  const AsdEmploymentHistoryScreen(
      {Key? key,
      required this.userFirstName,
      required this.userLastName,
      required this.userEmail,
      required this.userId,
      required this.isAddingNew,
      this.subCollectionId,
      this.listIndex,
      required this.userEmploymentHistoryList})
      : super(key: key);

  @override
  _AsdEmploymentHistoryScreenState createState() =>
      _AsdEmploymentHistoryScreenState();
}

class _AsdEmploymentHistoryScreenState
    extends State<AsdEmploymentHistoryScreen> {
  final ScrollController _scrollController = ScrollController();

  int textLen = 0;

  String? startDate;

  String? endDate;

  bool isDatePresent = false;

  DateTime leftSelectedDate = DateTime.now();

  DateTime rightSelectedDate = DateTime.now();

  List<EmploymentHistory?>? userEmploymentHistoryList;

  String? jobTitle;

  String? employer;

  String? city;

  String? description;

  bool isSaving = false;

  String btnText = 'Add';

  @override
  void initState() {
    super.initState();

    List<EmploymentHistory?> employmentHistoryListTemp =
        widget.userEmploymentHistoryList;

    userEmploymentHistoryList = employmentHistoryListTemp;

    if (!widget.isAddingNew) {
      btnText = 'Save';

      if (userEmploymentHistoryList![widget.listIndex!] != null) {
        EmploymentHistory? employmentHistoryTemp =
            userEmploymentHistoryList![widget.listIndex!];

        jobTitle = employmentHistoryTemp!.jobTitle;
        employer = employmentHistoryTemp.employer;
        startDate = employmentHistoryTemp.startDate;
        endDate = employmentHistoryTemp.endDate;
        city = employmentHistoryTemp.city;
        description = employmentHistoryTemp.description;

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
    bool wantDelete = await Utils.showCupertinoDialog(context);

    if (wantDelete) {
      setState(() {
        isSaving = true;
      });

      EmploymentHistory.deleteEmploymentHistoryToFirestore(
        userId: widget.userId,
        mySubCollectionId: widget.subCollectionId!,
      );

      userEmploymentHistoryList!.removeAt(widget.listIndex!);

      setState(() {
        isSaving = false;
      });

      Navigator.pop(context, userEmploymentHistoryList);
    }
  }

  Future<void> saveAddBtnOnPressed(BuildContext context) async {
    //Ensure all fields are not null
    if (jobTitle == null || jobTitle!.isEmpty) {
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
    if (employer == null || employer!.isEmpty) {
      Utils.showSnackBar(
        'Please enter your employer',
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
    if (city == null || city!.isEmpty) {
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
    if (description == null || description!.isEmpty) {
      Utils.showSnackBar(
        'Please enter your description',
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

    Navigator.pop(context, userEmploymentHistoryList);
  }

  Future<void> handleDataInFirebase() async {
    // Create the ProfessionalSummary class
    EmploymentHistory employmentHistory;

    if (widget.isAddingNew) {
      // Add the data in firestore

      // When creating, we use timestamp as unique id
      employmentHistory = EmploymentHistory(
        userId: widget.userId,
        subCollectionId: DateTime.now().microsecondsSinceEpoch.toString(),
        jobTitle: jobTitle!,
        employer: employer!,
        startDate: startDate!,
        endDate: endDate!,
        city: city!,
        description: description!,
      );

      // Add in firestore
      employmentHistory.addEmploymentHistoryToFirestore();

      // Update the list userEmploymentHistoryList
      userEmploymentHistoryList!.add(employmentHistory);
    } else {
      // Update the data (subcolectionId) in firestore
      // make sure subCollectionId is not null

      // When updating, we don't update the timestamp
      employmentHistory = EmploymentHistory(
        userId: widget.userId,
        subCollectionId: widget.subCollectionId!,
        jobTitle: jobTitle!,
        employer: employer!,
        startDate: startDate!,
        endDate: endDate!,
        city: city!,
        description: description!,
      );

      employmentHistory.updateEmploymentHistoryToFirestore();

      // Update the list userEmploymentHistoryList
      // Ensure listIndex is not null
      userEmploymentHistoryList![widget.listIndex!] = employmentHistory;
    }
  }

  void showDatePicker(Picker myPicker) {
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
                child: CupertinoExtended.CupertinoDatePicker(
                  mode: CupertinoExtended.CupertinoDatePickerMode.date,
                  onDateTimeChanged: (dateValue) {
                    myPicker == Picker.left
                        ? startDateOnChanged(dateValue)
                        : endDateOnChanged(dateValue);
                  },
                  initialDateTime: myPicker == Picker.left
                      ? leftSelectedDate
                      : rightSelectedDate,
                  minimumYear: 1950,
                  maximumYear: 2040,
                  // maximumDate: DateTime.now(),
                ),
              ),
            ],
          );
        });
  }

  void startDateOnChanged(dateValue) {
    leftSelectedDate = dateValue;
    startDate = DateFormat('MM/yyyy').format(dateValue);
  }

  void endDateOnChanged(dateValue) {
    rightSelectedDate = dateValue;
    endDate = DateFormat('MM/yyyy').format(dateValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundRiceWhite,
      appBar: AppBar(
        elevation: 0.5,
        //backgroundColor: kBackgroundRiceWhite,
        backgroundColor: kAutismBridgeBlue,
        title: const Text('Employment History'),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 0.5.h, vertical: 2.5.h),
          children: [
            ResumeBuilderInputField(
              onChanged: (text) {
                jobTitle = text;
              },
              initialValue: jobTitle,
              title: 'Job Title',
              hintText: 'e.g. Software Engineer',
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(
              height: 1.5.h,
            ),
            ResumeBuilderInputField(
              onChanged: (text) {
                employer = text;
              },
              initialValue: employer,
              title: 'Employer',
              hintText: 'e.g. Google',
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(
              height: 1.5.h,
            ),
            Row(
              children: [
                Expanded(
                  child: ResumeBuilderPicker(
                    bottomPadding: 0.0,
                    onPressed: () {
                      startDate =
                          DateFormat('MM/yyyy').format(leftSelectedDate);
                      return showDatePicker(Picker.left);
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
                  ),
                ),
                Expanded(
                  child: ResumeBuilderPicker(
                    bottomPadding: 0.0,
                    onPressed: () {
                      if (isDatePresent) {
                        return;
                      } else {
                        endDate =
                            DateFormat('MM/yyyy').format(rightSelectedDate);
                        return showDatePicker(Picker.right);
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
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 1.h),
              child: ResumeDateToggle(
                toggleText: 'Currently work here',
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
            ResumeBuilderInputField(
              onChanged: (text) {
                city = text;
              },
              initialValue: city,
              title: 'City',
              hintText: 'e.g. New York',
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(
              height: 1.5.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.5.h),
              child: ResumeBuilderParagraphField(
                  initialValue: description,
                  title: 'Description',
                  onChanged: (text) {
                    description = text;
                    setState(() {
                      textLen = text.length;
                    });
                  },
                  autoFocus: false,
                  minLines: 5,
                  maxLines: 8,
                  hintText: 'e.g. Created and implemented an official website',
                  scrollController: _scrollController,
                  textLen: textLen),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
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
                                  'Delete',
                                  style: TextStyle(
                                    fontSize: 12.5.sp,
                                    color: kAutismBridgeBlue,
                                  ),
                                ),
                          onPressed: isSaving
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
    );
  }
}