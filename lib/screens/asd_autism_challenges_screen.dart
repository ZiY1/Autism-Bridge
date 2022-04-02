import 'package:autism_bridge/color_constants.dart';
import 'package:autism_bridge/models/asd_user_credentials.dart';
import 'package:autism_bridge/models/autism_challenge_data.dart';
import 'package:autism_bridge/models/resume_data.dart';
import 'package:autism_bridge/screens/text_field_input_screen.dart';
import 'package:autism_bridge/widgets/my_card_widget.dart';
import 'package:autism_bridge/widgets/my_gradient_container.dart';
import 'package:autism_bridge/widgets/resume_builder_button.dart';
import 'package:autism_bridge/widgets/resume_builder_paragraph_field.dart';
import 'package:autism_bridge/widgets/input_holder.dart';
import 'package:autism_bridge/widgets/rounded_icon_container.dart';
import 'package:autism_bridge/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:autism_bridge/modified_flutter_packages/picker_from_pack.dart';
import 'package:sizer/sizer.dart';
import 'package:autism_bridge/models/resume_builder_picker_list.dart';

class AsdAutismChallengesScreen extends StatefulWidget {
  static const id = 'asd_challenges_screen';

  final AsdUserCredentials asdUserCredentials;

  final bool isAddingNew;

  final String? subCollectionId;

  final int? listIndex;

  final Resume userResume;

  const AsdAutismChallengesScreen({
    Key? key,
    required this.asdUserCredentials,
    required this.isAddingNew,
    this.subCollectionId,
    this.listIndex,
    required this.userResume,
  }) : super(key: key);

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

  bool isDeleting = false;

  final Widget seg = SizedBox(height: 1.h);

  @override
  void initState() {
    super.initState();

    List<AutismChallenge?> autismChallengeListTemp =
        widget.userResume.userAutismChallengeList;

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
    bool wantDelete = await Utils.showMyDialog(context);

    if (wantDelete) {
      setState(() {
        isDeleting = true;
      });

      await AutismChallenge.deleteAutismChallengeFromFirestore(
        userId: widget.asdUserCredentials.userId,
        mySubCollectionId: widget.subCollectionId!,
      );

      userAutismChallengeList!.removeAt(widget.listIndex!);

      setState(() {
        isDeleting = false;
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
    challengeDescription ??= '';

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
        userId: widget.asdUserCredentials.userId,
        subCollectionId: DateTime.now().microsecondsSinceEpoch.toString(),
        challengeName: challengeName!,
        challengeLevel: challengeLevel!,
        challengeDescription: challengeDescription!,
      );

      // Add in firestore
      await autismChallenge.addAutismChallengeToFirestore();

      // Update the list userEmploymentHistoryList
      userAutismChallengeList!.add(autismChallenge);
    } else {
      // Update the data (subcolectionId) in firestore
      // make sure subCollectionId is not null

      // When updating, we don't update the timestamp
      autismChallenge = AutismChallenge(
        userId: widget.asdUserCredentials.userId,
        subCollectionId: widget.subCollectionId!,
        challengeName: challengeName!,
        challengeLevel: challengeLevel!,
        challengeDescription: challengeDescription!,
      );

      await autismChallenge.updateAutismChallengeToFirestore();

      // Update the list userEmploymentHistoryList
      // Ensure listIndex is not null
      userAutismChallengeList![widget.listIndex!] = autismChallenge;
    }
  }

  void showPicker() {
    Utils.showMyCustomizedPicker(
      context: context,
      pickerData: conditionList,
      onConfirm: (Picker picker, List value) {
        String strTemp = picker.adapter.text;
        String strTempRemovedBracket = strTemp.substring(1, strTemp.length - 1);
        setState(() {
          challengeLevel = strTempRemovedBracket;
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
            'Autism Challenges',
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
              horizontal: 0.8.h,
              vertical: 0.9.h,
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
                            challengeName = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TextFieldInputScreen(
                                  title: 'Challenge',
                                  hintText: 'e.g. Social Phobia',
                                  userInput: challengeName,
                                  keyBoardType: TextInputType.text,
                                ),
                              ),
                            );
                            setState(() {});
                          },
                          title: 'Challenge',
                          bodyText: challengeName,
                          hintText: 'e.g. Social Phobia',
                          disableBorder: false,
                        ),
                        seg,
                        InputHolder(
                          onPressed: () {
                            return showPicker();
                          },
                          title: 'Challenge Level',
                          bodyText: challengeLevel,
                          hintText: 'Select your challenge level',
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
                            initialValue: challengeDescription,
                            title: 'Description (optional)',
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
                              saveAddBtnOnPressed(context);
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
