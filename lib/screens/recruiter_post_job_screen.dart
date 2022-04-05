import 'package:autism_bridge/icon_constants.dart';
import 'package:autism_bridge/models/address_info_returns.dart';
import 'package:autism_bridge/models/auto_complete_data_list.dart';
import 'package:autism_bridge/models/job_matching_picker_list.dart';
import 'package:autism_bridge/models/recruiter_job_post.dart';
import 'package:autism_bridge/models/recruiter_user_credentials.dart';
import 'package:autism_bridge/num_constants.dart';
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
import 'package:sizer/sizer.dart';
import '../color_constants.dart';
import 'package:autism_bridge/modified_flutter_packages/picker_from_pack.dart';
import '../regular_helpers.dart';
import 'google_places_search_screen.dart';

class RecruiterPostJobScreen extends StatefulWidget {
  static const id = 'recruiter_post_job_screen';

  final RecruiterUserCredentials recruiterUserCredentials;

  final bool isAddingNew;

  final String? subCollectionId;

  final int? listIndex;

  final List<RecruiterJobPost?> recruiterJobPostList;

  const RecruiterPostJobScreen({
    Key? key,
    required this.recruiterUserCredentials,
    required this.isAddingNew,
    this.subCollectionId,
    this.listIndex,
    required this.recruiterJobPostList,
  }) : super(key: key);

  @override
  State<RecruiterPostJobScreen> createState() => _RecruiterPostJobScreenState();
}

class _RecruiterPostJobScreenState extends State<RecruiterPostJobScreen> {
  final ScrollController _scrollController = ScrollController();

  int textLen = 0;

  bool isSaving = false;

  bool isDeleting = false;

  String btnText = 'Add';

  // Temp Recruiter Job post variable
  String? jobName;

  String? employmentType;

  String? jobCategory;

  String? jobTitle;

  String? jobCity;

  String? jobState;

  String? jobAddress;

  String? minExperience;

  String? minEducation;

  double? minSalary;

  double? maxSalary;

  String? jobDescription;

  double? lat;

  double? lng;

  List<RecruiterJobPost?>? recruiterJobPostList;

  Future<void> deleteBtnOnPressed() async {
    bool wantDelete = await Utils.showMyDialog(context);

    if (wantDelete) {
      setState(() {
        isDeleting = true;
      });

      try {
        // First delete the record in recruiter_job_post collection
        await RecruiterJobPost.deleteMyJobPostInRecruiterJobPostInFirestore(
          userId: widget.recruiterUserCredentials.userId,
          // it won't be null because by entering the delete mode, we will pass the subCollectionId
          mySubCollectionId: widget.subCollectionId!,
        );

        // Second delete the record in all_jobs collection
        await RecruiterJobPost.deleteMyJobPostToAllJobPostInFirestore(
          subCollectionId: widget.subCollectionId!,
        );
      } on FirebaseException catch (e) {
        Utils.showSnackBar(
          e.message,
          kErrorIcon,
        );
        return;
      }

      recruiterJobPostList!.removeAt(widget.listIndex!);

      setState(() {
        isDeleting = false;
      });

      Navigator.pop(context, recruiterJobPostList);
    }
  }

  Future<void> saveAddBtnOnPressed() async {
    //Ensure all fields are not null
    if (jobName == null || jobName!.isEmpty) {
      Utils.showSnackBar(
        'Please enter job title',
        kErrorIcon,
      );
      return;
    }

    if (jobCategory == null ||
        jobCategory!.isEmpty ||
        jobTitle == null ||
        jobTitle!.isEmpty) {
      Utils.showSnackBar(
        'Please enter the job category',
        kErrorIcon,
      );
      return;
    }

    if (employmentType == null || employmentType!.isEmpty) {
      Utils.showSnackBar(
        'Please select the job type',
        kErrorIcon,
      );
      return;
    }

    if (minExperience == null || minExperience!.isEmpty) {
      Utils.showSnackBar(
        'Please select the minimum experience required',
        kErrorIcon,
      );
      return;
    }

    if (minEducation == null || minEducation!.isEmpty) {
      Utils.showSnackBar(
        'Please select the minimum education required',
        kErrorIcon,
      );
      return;
    }

    if (minSalary == null || maxSalary == null) {
      Utils.showSnackBar(
        'Please select the job salary range',
        kErrorIcon,
      );
      return;
    }

    if (jobCity == null ||
        jobCity!.isEmpty ||
        jobState == null ||
        jobState!.isEmpty) {
      Utils.showSnackBar(
        'Please select the job city',
        kErrorIcon,
      );
      return;
    }

    if (jobAddress == null || jobAddress!.isEmpty) {
      Utils.showSnackBar(
        'Please enter the job full address',
        kErrorIcon,
      );
      return;
    }

    if (jobDescription == null || jobDescription!.isEmpty) {
      Utils.showSnackBar(
        'Please enter the job description',
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

    Navigator.pop(context, recruiterJobPostList);
  }

  Future<void> handleDataInFirebase() async {
    // Create the JobPreference class
    RecruiterJobPost recruiterJobPost;

    if (widget.isAddingNew) {
      // Add the data in firestore

      // When creating, we use timestamp as unique id
      recruiterJobPost = RecruiterJobPost(
        userId: widget.recruiterUserCredentials.userId,
        subCollectionId: DateTime.now().microsecondsSinceEpoch.toString(),
        employmentType: employmentType,
        jobName: jobName,
        jobCategory: jobCategory,
        jobTitle: jobTitle,
        jobCity: jobCity,
        jobState: jobState,
        jobAddress: jobAddress,
        minExperience: minExperience,
        minEducation: minEducation,
        minSalary: minSalary,
        maxSalary: maxSalary,
        jobDescription: jobDescription,
        lat: lat,
        lng: lng,
      );

      // Add in firestore
      try {
        // First add it to recruiter_job_post collection
        await recruiterJobPost.addMyJobPostToRecruiterJobPostInFirestore();
        // Second add it to all_jobs collection
        await recruiterJobPost.addMyJobPostToAllJobPostInFirestore();
      } on FirebaseException catch (e) {
        Utils.showSnackBar(
          e.message,
          kErrorIcon,
        );
        return;
      }

      // Update the list recruiterJobPostList
      recruiterJobPostList!.add(recruiterJobPost);
    } else {
      // Update the data (subcolectionId) in firestore
      // make sure subCollectionId is not null

      // When updating, we don't update the timestamp
      recruiterJobPost = RecruiterJobPost(
        userId: widget.recruiterUserCredentials.userId,
        subCollectionId: widget.subCollectionId!,
        employmentType: employmentType,
        jobName: jobName,
        jobCategory: jobCategory,
        jobTitle: jobTitle,
        jobCity: jobCity,
        jobState: jobState,
        jobAddress: jobAddress,
        minExperience: minExperience,
        minEducation: minEducation,
        minSalary: minSalary,
        maxSalary: maxSalary,
        jobDescription: jobDescription,
        lat: lat,
        lng: lng,
      );

      try {
        // First update it to recruiter_job_post collection
        await recruiterJobPost.updateMyJobPostToRecruiterJobPostInFirestore();
        // Second update it to all_jobs collection
        await recruiterJobPost.updateMyJobPostToAllJobPostInFirestore();
      } on FirebaseException catch (e) {
        Utils.showSnackBar(
          e.message,
          kErrorIcon,
        );
        return;
      }

      // Update the list recruiterJobPostList
      // Ensure listIndex is not null
      recruiterJobPostList![widget.listIndex!] = recruiterJobPost;
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
          employmentType = strTempRemovedBracket;
        });
      },
      smallerText: false,
    );
  }

  void showMinExperiencePicker() {
    Utils.showMyCustomizedPicker(
      context: context,
      pickerData: experienceRequireList,
      onConfirm: (Picker picker, List value) {
        String strTemp = picker.adapter.text;
        String strTempRemovedBracket = strTemp.substring(1, strTemp.length - 1);
        setState(() {
          minExperience = strTempRemovedBracket;
        });
      },
      smallerText: false,
    );
  }

  void showMinEducationPicker() {
    Utils.showMyCustomizedPicker(
      context: context,
      pickerData: educationRequireList,
      onConfirm: (Picker picker, List value) {
        String strTemp = picker.adapter.text;
        String strTempRemovedBracket = strTemp.substring(1, strTemp.length - 1);
        setState(() {
          minEducation = strTempRemovedBracket;
        });
      },
      smallerText: false,
    );
  }

  void showJobCategoryPicker() {
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
          jobCategory = leftValueTemp;
          jobTitle = rightValueTemp;
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
          jobState = leftValueTemp;
          jobCity = rightValueTemp;
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
          minSalary = RegularHelpers.getSalaryAsNumberStr(leftValueTemp);
          maxSalary = RegularHelpers.getSalaryAsNumberStr(rightValueTemp);
        });
      },
      smallerText: false,
    );
  }

  @override
  void initState() {
    super.initState();

    recruiterJobPostList = widget.recruiterJobPostList;

    if (!widget.isAddingNew) {
      btnText = 'Save';

      if (recruiterJobPostList![widget.listIndex!] != null) {
        RecruiterJobPost? recruiterJobPostTemp =
            recruiterJobPostList![widget.listIndex!];

        jobName = recruiterJobPostTemp!.jobName;

        employmentType = recruiterJobPostTemp.employmentType;

        jobCategory = recruiterJobPostTemp.jobCategory;

        jobTitle = recruiterJobPostTemp.jobTitle;

        jobCity = recruiterJobPostTemp.jobCity;

        jobState = recruiterJobPostTemp.jobState;

        jobAddress = recruiterJobPostTemp.jobAddress;

        minExperience = recruiterJobPostTemp.minExperience;

        minEducation = recruiterJobPostTemp.minEducation;

        minSalary = recruiterJobPostTemp.minSalary;

        maxSalary = recruiterJobPostTemp.maxSalary;

        jobDescription = recruiterJobPostTemp.jobDescription;

        textLen = jobDescription!.length;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget seg = SizedBox(height: 1.h);
    return MyGradientContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: const Text(
            'Job Posting',
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
                        InputHolder(
                          onPressed: () async {
                            jobName = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TextFieldInputScreen(
                                  title: 'Job Title',
                                  hintText: 'e.g. Software Engineer',
                                  userInput: jobName,
                                  keyBoardType: TextInputType.text,
                                  autoCompleteList: jobTitlesList,
                                ),
                              ),
                            );
                            setState(() {});
                          },
                          title: 'Job Title',
                          bodyText: jobName,
                          hintText: 'e.g. Software Engineer',
                          disableBorder: false,
                        ),
                        seg,
                        InputHolder(
                          onPressed: () {
                            showJobCategoryPicker();
                          },
                          title: 'Job Category',
                          bodyText: jobCategory == null && jobTitle == null
                              ? null
                              : '${jobCategory!} , ${jobTitle!}',
                          hintText: 'Select your category & job title',
                          disableBorder: false,
                        ),
                        seg,
                        InputHolder(
                          onPressed: () {
                            showEmpTypePicker();
                          },
                          title: 'Employment Type',
                          bodyText: employmentType,
                          hintText: 'select the employment type',
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
                        InputHolder(
                          onPressed: () {
                            showMinExperiencePicker();
                          },
                          title: 'Minimum Experience',
                          bodyText: minExperience,
                          hintText: 'select the minimum experience required',
                          disableBorder: false,
                        ),
                        seg,
                        InputHolder(
                          onPressed: () {
                            showMinEducationPicker();
                          },
                          title: 'Minimum Education',
                          bodyText: minEducation,
                          hintText: 'select the minimum education required',
                          disableBorder: false,
                        ),
                        seg,
                        InputHolder(
                          onPressed: () {
                            showSalaryRangePicker();
                          },
                          title: 'Job Monthly Salary',
                          bodyText: minSalary == null && maxSalary == null
                              ? null
                              : maxSalary! == kEmpty
                                  ? minSalary == kNone
                                      ? 'None'
                                      : minSalary == kMinSalaryLimit
                                          ? '< ${minSalary}k'
                                          : '> ${minSalary}k'
                                  : '${minSalary!}k - ${maxSalary!}k',
                          hintText: 'Select the job monthly salary range',
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
                        InputHolder(
                          onPressed: () {
                            showCityStatePicker();
                          },
                          title: 'Job City',
                          bodyText: jobState == null && jobCity == null
                              ? null
                              : '${jobCity!} , ${jobState!}',
                          hintText: 'Select the job city',
                          disableBorder: false,
                        ),
                        seg,
                        InputHolder(
                          onPressed: () async {
                            AddressInfoReturns? addressInfoReturns =
                                await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GooglePlacesSearchScreen(
                                  title: 'Job Address',
                                  hintText: 'Enter your job full address',
                                  userInput: jobAddress,
                                ),
                              ),
                            );
                            if (addressInfoReturns != null) {
                              lat = addressInfoReturns.lat;
                              lng = addressInfoReturns.lng;
                              setState(() {
                                jobAddress = addressInfoReturns.address;
                              });
                            }
                          },
                          title: 'Job Address',
                          bodyText: jobAddress,
                          hintText: 'Enter your job full address',
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
                            initialValue: jobDescription,
                            title: 'Job Description',
                            onChanged: (text) {
                              jobDescription = text;
                              setState(() {
                                textLen = text.length;
                              });
                            },
                            autoFocus: false,
                            minLines: 8,
                            maxLines: 16,
                            hintText:
                                'Describe the job requirements and responsibilities',
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
              child: widget.isAddingNew
                  ? MyBottomButton(
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
                              saveAddBtnOnPressed();
                            },
                      isHollow: false,
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: MyBottomButton(
                            child: isDeleting
                                ? SizedBox(
                                    width: 3.18.h,
                                    height: 3.18.h,
                                    child: const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(
                                        kAutismBridgeBlue,
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
                                    deleteBtnOnPressed();
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
                                    btnText,
                                    style: TextStyle(
                                      fontSize: 12.5.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                            onPressed: isSaving
                                ? null
                                : () {
                                    saveAddBtnOnPressed();
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
