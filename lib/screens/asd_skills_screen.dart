import 'package:autism_bridge/constants.dart';
import 'package:autism_bridge/models/resume_builder_picker_list.dart';
import 'package:autism_bridge/models/skill_data.dart';
import 'package:autism_bridge/widgets/resume_builder_button.dart';
import 'package:autism_bridge/widgets/resume_builder_input_field.dart';
import 'package:autism_bridge/widgets/resume_builder_paragraph_field.dart';
import 'package:autism_bridge/widgets/resume_builder_picker.dart';
import 'package:autism_bridge/widgets/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AsdSkillsScreen extends StatefulWidget {
  static const id = 'asd_skills_screen';

  final String userFirstName;

  final String userLastName;

  final String userEmail;

  final String userId;

  final bool isAddingNew;

  final String? subCollectionId;

  final int? listIndex;

  final List<Skill?> userSkillList;

  const AsdSkillsScreen(
      {Key? key,
      required this.userFirstName,
      required this.userLastName,
      required this.userEmail,
      required this.userId,
      required this.isAddingNew,
      this.subCollectionId,
      this.listIndex,
      required this.userSkillList})
      : super(key: key);

  @override
  _AsdSkillsScreenState createState() => _AsdSkillsScreenState();
}

class _AsdSkillsScreenState extends State<AsdSkillsScreen> {
  final ScrollController _scrollController = ScrollController();

  int textLen = 0;

  String? skillName;

  String? skillLevel;

  String? skillDescription;

  List<Skill?>? userSkillList;

  String btnText = 'Add';

  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    List<Skill?> skillListTemp = widget.userSkillList;

    userSkillList = skillListTemp;

    if (!widget.isAddingNew) {
      btnText = 'Save';

      if (userSkillList![widget.listIndex!] != null) {
        Skill? skillTemp = userSkillList![widget.listIndex!];

        skillName = skillTemp!.skillName;
        skillLevel = skillTemp.skillLevel;
        skillDescription = skillTemp.skillDescription;

        textLen = skillDescription!.length;
      }
    }
  }

  Future<void> deleteBtnOnPressed(BuildContext context) async {
    bool wantDelete = await Utils.showCupertinoDialog(context);

    if (wantDelete) {
      setState(() {
        isSaving = true;
      });

      Skill.deleteSkillFromFirestore(
        userId: widget.userId,
        mySubCollectionId: widget.subCollectionId!,
      );

      userSkillList!.removeAt(widget.listIndex!);

      setState(() {
        isSaving = false;
      });

      Navigator.pop(context, userSkillList);
    }
  }

  Future<void> saveAddBtnOnPressed(BuildContext context) async {
    //Ensure all fields are not null
    if (skillName == null || skillName!.isEmpty) {
      Utils.showSnackBar(
        'Please enter your skill name',
        const Icon(
          Icons.error_sharp,
          color: Colors.red,
          size: 30.0,
        ),
      );
      return;
    }
    if (skillLevel == null || skillLevel!.isEmpty) {
      Utils.showSnackBar(
        'Please select your skill level',
        const Icon(
          Icons.error_sharp,
          color: Colors.red,
          size: 30.0,
        ),
      );
      return;
    }
    if (skillDescription == null || skillDescription!.isEmpty) {
      Utils.showSnackBar(
        'Please enter your skill description',
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

    Navigator.pop(context, userSkillList);
  }

  Future<void> handleDataInFirebase() async {
    // Create the ProfessionalSummary class
    Skill skill;

    if (widget.isAddingNew) {
      // Add the data in firestore

      // When creating, we use timestamp as unique id
      skill = Skill(
        userId: widget.userId,
        subCollectionId: DateTime.now().microsecondsSinceEpoch.toString(),
        skillName: skillName!,
        skillLevel: skillLevel!,
        skillDescription: skillDescription!,
      );

      // Add in firestore
      skill.addSkillToFirestore();

      // Update the list userEmploymentHistoryList
      userSkillList!.add(skill);
    } else {
      // Update the data (subcolectionId) in firestore
      // make sure subCollectionId is not null

      // When updating, we don't update the timestamp
      skill = Skill(
        userId: widget.userId,
        subCollectionId: widget.subCollectionId!,
        skillName: skillName!,
        skillLevel: skillLevel!,
        skillDescription: skillDescription!,
      );

      skill.updateSkillToFirestore();

      // Update the list userEmploymentHistoryList
      // Ensure listIndex is not null
      userSkillList![widget.listIndex!] = skill;
    }
  }

  void showPicker() {
    List<Text> cupertinoPickerList = [];

    for (String name in skillList) {
      cupertinoPickerList.add(Text(name));
    }

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
                height: MediaQuery.of(context).copyWith().size.height * 0.25,
                color: kCupertinoPickerBackgroundGrey,
                child: CupertinoPicker(
                  itemExtent: 4.5.h,
                  onSelectedItemChanged: (int selectedItem) {
                    skillLevel = skillList[selectedItem];
                  },
                  children: cupertinoPickerList,
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
        title: const Text('Skills'),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 0.5.h, vertical: 2.5.h),
          children: [
            ResumeBuilderInputField(
              onChanged: (text) {
                skillName = text;
              },
              initialValue: skillName,
              title: 'Skill',
              hintText: 'e.g. Drawing',
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(
              height: 1.5.h,
            ),
            ResumeBuilderPicker(
              onPressed: () {
                skillLevel = skillList[0];
                return showPicker();
              },
              title: 'Skill Level',
              bodyText: skillLevel == null
                  ? Text(
                      'Select your skill level',
                      style: TextStyle(
                        fontSize: 9.5.sp,
                        color: Colors.grey.shade400,
                      ),
                    )
                  : Text(
                      skillLevel!,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: const Color(0xFF1F1F39),
                      ),
                    ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.5.h),
              child: ResumeBuilderParagraphField(
                initialValue: skillDescription,
                title: 'Description',
                onChanged: (text) {
                  skillDescription = text;
                  setState(() {
                    textLen = text.length;
                  });
                },
                autoFocus: false,
                minLines: 5,
                maxLines: 8,
                hintText: 'Simply describe your skill',
                scrollController: _scrollController,
                textLen: textLen,
              ),
            ),
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

// TODO: Modify and use the following UI if have time
// Two rows:

// Row(
// children: [
// Padding(
// padding: EdgeInsets.only(left: 0.5.h, bottom: 0.3.h),
// child: Text(
// 'Level - ',
// style: TextStyle(
// color: const Color(0xFF858597),
// fontSize: 10.sp,
// ),
// ),
// ),
// Padding(
// padding: EdgeInsets.only(bottom: 0.3.h),
// child: Text(
// 'Beginner',
// style: TextStyle(
// color: const Color(0xFF858597),
// fontSize: 10.sp,
// ),
// ),
// ),
// ],
// ),
// Row(
// children: [
// Expanded(
// child: TextButton(
// child: AnimatedContainer(
// color: pageIndex == 1
// ? Color(0xFF4B4B4B)
// : Color(0xFFD8D8D8),
// duration: Duration(milliseconds: 300),
// ),
// style: ButtonStyle(
// padding: MaterialStateProperty.all<EdgeInsets>(
// EdgeInsets.all(1.55.h),
// ),
// // backgroundColor: MaterialStateProperty.all<Color>(
// //   const Color(0xFFFFEEEE),
// // ),
// shape: MaterialStateProperty.all<
//     RoundedRectangleBorder>(
// const RoundedRectangleBorder(
// borderRadius: BorderRadius.only(
// topLeft: Radius.circular(12.0),
// bottomLeft: Radius.circular(12.0),
// ),
// ),
// ),
// ),
// onPressed: () {
// setState(() {
// pageIndex = 1;
// });
// },
// ),
// ),
// Expanded(
// child: TextButton(
// child: const Text(''),
// style: ButtonStyle(
// padding: MaterialStateProperty.all<EdgeInsets>(
// EdgeInsets.all(1.55.h),
// ),
// backgroundColor: MaterialStateProperty.all<Color>(
// const Color(0xFFFFEEEE),
// ),
// ),
// onPressed: () {},
// ),
// ),
// Expanded(
// child: TextButton(
// child: const Text(''),
// style: ButtonStyle(
// padding: MaterialStateProperty.all<EdgeInsets>(
// EdgeInsets.all(1.55.h),
// ),
// backgroundColor: MaterialStateProperty.all<Color>(
// const Color(0xFFFFEEEE),
// ),
// ),
// onPressed: () {},
// ),
// ),
// Expanded(
// child: TextButton(
// child: const Text(''),
// style: ButtonStyle(
// padding: MaterialStateProperty.all<EdgeInsets>(
// EdgeInsets.all(1.55.h),
// ),
// backgroundColor: MaterialStateProperty.all<Color>(
// const Color(0xFFFFEEEE),
// ),
// ),
// onPressed: () {},
// ),
// ),
// Expanded(
// child: TextButton(
// child: const Text(''),
// style: ButtonStyle(
// padding: MaterialStateProperty.all<EdgeInsets>(
// EdgeInsets.all(1.55.h),
// ),
// backgroundColor: MaterialStateProperty.all<Color>(
// const Color(0xFFFFE0E0),
// ),
// shape: MaterialStateProperty.all<
//     RoundedRectangleBorder>(
// const RoundedRectangleBorder(
// borderRadius: BorderRadius.only(
// topRight: Radius.circular(12.0),
// bottomRight: Radius.circular(12.0),
// ),
// ),
// ),
// ),
// onPressed: () {},
// ),
// ),
// ],
// ),
