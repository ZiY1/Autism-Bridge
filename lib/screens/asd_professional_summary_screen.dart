import 'package:autism_bridge/constants.dart';
import 'package:autism_bridge/firebase_helpers.dart';
import 'package:autism_bridge/models/professional_summary_data.dart';
import 'package:autism_bridge/widgets/my_card_widget.dart';
import 'package:autism_bridge/widgets/resume_builder_button.dart';
import 'package:autism_bridge/widgets/resume_builder_paragraph_field.dart';
import 'package:autism_bridge/widgets/rounded_icon_container.dart';
import 'package:autism_bridge/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AsdProfessionalSummaryScreen extends StatefulWidget {
  static const id = 'asd_professional_summary_screen';

  final String userFirstName;

  final String userLastName;

  final String userEmail;

  final String userId;

  final ProfessionalSummary? userProfessionalSummary;

  const AsdProfessionalSummaryScreen(
      {Key? key,
      required this.userFirstName,
      required this.userLastName,
      required this.userEmail,
      required this.userId,
      required this.userProfessionalSummary})
      : super(key: key);

  @override
  _AsdProfessionalSummaryScreenState createState() =>
      _AsdProfessionalSummaryScreenState();
}

class _AsdProfessionalSummaryScreenState
    extends State<AsdProfessionalSummaryScreen> {
  final ScrollController _scrollController = ScrollController();

  int textLen = 0;

  ProfessionalSummary? userProfessionalSummary;

  String? summaryText;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    ProfessionalSummary? professionalSummaryTemp =
        widget.userProfessionalSummary;

    if (professionalSummaryTemp != null) {
      userProfessionalSummary = professionalSummaryTemp;
      summaryText = professionalSummaryTemp.summaryText;
      textLen = summaryText!.length;
    }
  }

  Future<void> saveButtonOnPressed() async {
    // Ensure all fields are not null
    if (summaryText == null || summaryText!.isEmpty) {
      Utils.showSnackBar(
        'Please enter your summary',
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

    Navigator.pop(context, userProfessionalSummary);

    // save it to firebase
  }

  Future<void> handleDataInFirebase() async {
    // Create the ProfessionalSummary class
    ProfessionalSummary professionalSummary = ProfessionalSummary(
      userId: widget.userId,
      summaryText: summaryText!,
    );

    // Check if userId's document exists, if no, create one
    bool docExists = await FirebaseHelper.checkDocumentExists(
        collectionName: 'cv_professional_summary', docID: widget.userId);
    if (!docExists) {
      ProfessionalSummary.createProfessionalSummaryInFirestore(
          userId: widget.userId);
    }

    // Update in firestore
    professionalSummary.updateProfessionalSummaryToFirestore();

    // Update the var userProfessionalSummary
    userProfessionalSummary = professionalSummary;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [
            0.01,
            0.25,
          ],
          colors: [
            Color(0xFFE7F0F9),
            //kAutismBridgeBlue,
            kBackgroundRiceWhite,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: const Text(
            'Professional Summary',
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
                  horizontal: 1.h,
                  vertical: 1.2.h,
                ),
                child: MyCardWidget(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.h, vertical: 2.h),
                    child: ResumeBuilderParagraphField(
                      initialValue: summaryText,
                      scrollController: _scrollController,
                      textLen: textLen,
                      maxLines: 8,
                      minLines: 8,
                      onChanged: (text) {
                        summaryText = text;
                        setState(() {
                          textLen = text.length;
                        });
                      },
                      title:
                          'Write 2-4 short & energetic sentences to interest the reader! Mention your role, experience, best qualities and skills.',
                      hintText:
                          'e.g. Passionate about coding, love building apps, desire to write simple yet powerful code.',
                      autoFocus: true,
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
      ),
    );
  }
}
