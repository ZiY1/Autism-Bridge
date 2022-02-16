import 'package:autism_bridge/constants.dart';
import 'package:autism_bridge/models/autism_challenge_data.dart';
import 'package:autism_bridge/widgets/resume_builder_button.dart';
import 'package:autism_bridge/widgets/resume_builder_input_field.dart';
import 'package:autism_bridge/widgets/resume_builder_paragraph_field.dart';
import 'package:autism_bridge/widgets/resume_builder_picker.dart';
import 'package:autism_bridge/widgets/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:autism_bridge/models/resume_builder_picker_list.dart';

class AsdAutismChallengesScreen extends StatefulWidget {
  static const id = 'asd_challenges_screen';

  final String userFirstName;

  final String userLastName;

  final String userEmail;

  final String userId;

  final bool isAddingNew;

  final String? subCollectionId;

  final int? listIndex;

  final List<AutismChallenge?> userAutismChallengeList;

  const AsdAutismChallengesScreen(
      {Key? key,
      required this.userFirstName,
      required this.userLastName,
      required this.userEmail,
      required this.userId,
      required this.isAddingNew,
      this.subCollectionId,
      this.listIndex,
      required this.userAutismChallengeList})
      : super(key: key);

  @override
  _AsdAutismChallengesScreenState createState() =>
      _AsdAutismChallengesScreenState();
}

class _AsdAutismChallengesScreenState extends State<AsdAutismChallengesScreen> {
  final ScrollController _scrollController = ScrollController();

  int textLen = 0;

  String? challengeName;

  String? challengeLevel;

  String? challengeDescription;

  List<AutismChallenge?>? userAutismChallengeList;

  String btnText = 'Add';

  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    List<AutismChallenge?> autismChallengeListTemp =
        widget.userAutismChallengeList;

    userAutismChallengeList = autismChallengeListTemp;

    if (!widget.isAddingNew) {
      btnText = 'Save';

      if (userAutismChallengeList![widget.listIndex!] != null) {
        AutismChallenge? autismChallengeTemp =
            userAutismChallengeList![widget.listIndex!];

        challengeName = autismChallengeTemp!.challengeName;
        challengeLevel = autismChallengeTemp.challengeLevel;
        challengeDescription = autismChallengeTemp.challengeDescription;

        textLen = challengeDescription!.length;
      }
    }
  }

  Future<void> deleteBtnOnPressed(BuildContext context) async {
    bool wantDelete = await Utils.showCupertinoDialog(context);

    if (wantDelete) {
      setState(() {
        isSaving = true;
      });

      AutismChallenge.deleteAutismChallengeFromFirestore(
        userId: widget.userId,
        mySubCollectionId: widget.subCollectionId!,
      );

      userAutismChallengeList!.removeAt(widget.listIndex!);

      setState(() {
        isSaving = false;
      });

      Navigator.pop(context, userAutismChallengeList);
    }
  }

  Future<void> saveAddBtnOnPressed(BuildContext context) async {
    //Ensure all fields are not null
    if (challengeName == null || challengeName!.isEmpty) {
      Utils.showSnackBar(
        'Please enter your challenge name',
        const Icon(
          Icons.error_sharp,
          color: Colors.red,
          size: 30.0,
        ),
      );
      return;
    }
    if (challengeLevel == null || challengeLevel!.isEmpty) {
      Utils.showSnackBar(
        'Please select your challenge level',
        const Icon(
          Icons.error_sharp,
          color: Colors.red,
          size: 30.0,
        ),
      );
      return;
    }
    if (challengeDescription == null || challengeDescription!.isEmpty) {
      Utils.showSnackBar(
        'Please enter your challenge description',
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

    Navigator.pop(context, userAutismChallengeList);
  }

  Future<void> handleDataInFirebase() async {
    // Create the ProfessionalSummary class
    AutismChallenge autismChallenge;

    if (widget.isAddingNew) {
      // Add the data in firestore

      // When creating, we use timestamp as unique id
      autismChallenge = AutismChallenge(
        userId: widget.userId,
        subCollectionId: DateTime.now().microsecondsSinceEpoch.toString(),
        challengeName: challengeName!,
        challengeLevel: challengeLevel!,
        challengeDescription: challengeDescription!,
      );

      // Add in firestore
      autismChallenge.addAutismChallengeToFirestore();

      // Update the list userEmploymentHistoryList
      userAutismChallengeList!.add(autismChallenge);
    } else {
      // Update the data (subcolectionId) in firestore
      // make sure subCollectionId is not null

      // When updating, we don't update the timestamp
      autismChallenge = AutismChallenge(
        userId: widget.userId,
        subCollectionId: widget.subCollectionId!,
        challengeName: challengeName!,
        challengeLevel: challengeLevel!,
        challengeDescription: challengeDescription!,
      );

      autismChallenge.updateAutismChallengeToFirestore();

      // Update the list userEmploymentHistoryList
      // Ensure listIndex is not null
      userAutismChallengeList![widget.listIndex!] = autismChallenge;
    }
  }

  void showPicker() {
    List<Text> cupertinoPickerList = [];

    for (String levelName in levelList) {
      cupertinoPickerList.add(Text(levelName));
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
                    challengeLevel = levelList[selectedItem];
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
        title: const Text('Autism Challenges'),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 0.5.h, vertical: 2.5.h),
          children: [
            ResumeBuilderInputField(
              onChanged: (text) {
                challengeName = text;
              },
              initialValue: challengeName,
              title: 'Challenge',
              hintText: 'e.g. Social Phobia',
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(
              height: 1.5.h,
            ),
            ResumeBuilderPicker(
              onPressed: () {
                challengeLevel = levelList[0];
                return showPicker();
              },
              title: 'Challenge Level',
              bodyText: challengeLevel == null
                  ? Text(
                      'Select your challenge level',
                      style: TextStyle(
                        fontSize: 9.5.sp,
                        color: Colors.grey.shade400,
                      ),
                    )
                  : Text(
                      challengeLevel!,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: const Color(0xFF1F1F39),
                      ),
                    ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.5.h),
              child: ResumeBuilderParagraphField(
                initialValue: challengeDescription,
                title: 'Description',
                onChanged: (text) {
                  challengeDescription = text;
                  setState(() {
                    textLen = text.length;
                  });
                },
                autoFocus: false,
                minLines: 5,
                maxLines: 8,
                hintText:
                    'Simply describe your challenge to help recruiters better understand you',
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
