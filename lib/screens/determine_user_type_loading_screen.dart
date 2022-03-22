import 'package:autism_bridge/models/asd_user_credentials.dart';
import 'package:autism_bridge/models/autism_challenge_data.dart';
import 'package:autism_bridge/models/education_data.dart';
import 'package:autism_bridge/models/employment_history_data.dart';
import 'package:autism_bridge/models/job_preference_data.dart';
import 'package:autism_bridge/models/personal_details_data.dart';
import 'package:autism_bridge/models/professional_summary_data.dart';
import 'package:autism_bridge/models/recruiter_company_info.dart';
import 'package:autism_bridge/models/recruiter_profile.dart';
import 'package:autism_bridge/models/recruiter_user_credentials.dart';
import 'package:autism_bridge/models/resume_data.dart';
import 'package:autism_bridge/models/skill_data.dart';
import 'package:autism_bridge/screens/asd_home_screen.dart';
import 'package:autism_bridge/screens/recruiter_home_screen.dart';
import 'package:autism_bridge/screens/recruiter_profile_screen.dart';
import 'package:autism_bridge/widgets/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import '../icon_constants.dart';
import 'asd_personal_details_screen.dart';

class DetermineUserTypeLoadingScreen extends StatefulWidget {
  static const id = 'determine_user_type_screen';
  const DetermineUserTypeLoadingScreen({Key? key}) : super(key: key);

  @override
  _DetermineUserTypeLoadingScreenState createState() =>
      _DetermineUserTypeLoadingScreenState();
}

class _DetermineUserTypeLoadingScreenState
    extends State<DetermineUserTypeLoadingScreen> {
  final _auth = FirebaseAuth.instance;

  final _firestore = FirebaseFirestore.instance;

  String? userType;

  AsdUserCredentials? asdUserCredentials;

  RecruiterUserCredentials? recruiterUserCredentials;

  Resume? userResume;

  List<JobPreference?>? userJobPreferenceList;

  RecruiterProfile? recruiterProfile;

  RecruiterCompanyInfo? recruiterCompanyInfo;

  Future<void> fetchUserInfo() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    try {
      await FirebaseFirestore.instance
          .collection('all_users')
          .doc(userId)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;
          userType = data['userType'];

          // Determine the userType
          if (userType == 'JobSeeker') {
            // Fetch Asd user credentials
            String userId;
            String userEmail;
            bool isFirstTimeIn;

            // Fetch user id and email from firebaseAuth
            try {
              final user = _auth.currentUser;
              if (user != null) {
                userEmail = user.email!;
                userId = user.uid;

                // Once fetch id success, Fetch user name from firebaseAuth
                await _firestore
                    .collection('job_seeker_users')
                    .doc(userId)
                    .get()
                    .then((DocumentSnapshot documentSnapshot) async {
                  if (documentSnapshot.exists) {
                    Map<String, dynamic> data =
                        documentSnapshot.data() as Map<String, dynamic>;
                    isFirstTimeIn = data['isFirstTimeIn'];

                    // store credential into the AsdUserCredentials class
                    asdUserCredentials = AsdUserCredentials(
                      userId: userId,
                      userEmail: userEmail,
                      isFirstTimeIn: isFirstTimeIn,
                    );

                    List<EmploymentHistory?> employmentHistoryTemp = [];
                    List<Education?> educationTemp = [];
                    List<Skill?> skillTemp = [];
                    List<AutismChallenge?> autismChallengeTemp = [];

                    Resume resumeTemp = Resume(
                        userPersonalDetails: null,
                        userProfessionalSummary: null,
                        userEmploymentHistoryList: employmentHistoryTemp,
                        userEducationList: educationTemp,
                        userSkillList: skillTemp,
                        userAutismChallengeList: autismChallengeTemp);

                    // If user is not first time in, fetch the personal details and job preference list
                    if (!isFirstTimeIn) {
                      // Read the resume data
                      resumeTemp.setPersonalDetails = await PersonalDetails
                          .readPersonalDetailsDataFromFirestore(
                              asdUserCredentials!.userId);

                      resumeTemp.setProfessionalSummary =
                          await ProfessionalSummary
                              .readProfessionalSummaryDataFromFirestore(
                                  asdUserCredentials!.userId);

                      resumeTemp.setEmploymentHistoryList =
                          await EmploymentHistory
                              .readAllEmploymentHistoryDataFromFirestore(
                                  userId: asdUserCredentials!.userId);

                      resumeTemp.setEducationList =
                          await Education.readAllEducationDataFromFirestore(
                              userId: asdUserCredentials!.userId);

                      resumeTemp.setSkillList =
                          await Skill.readAllSkillDataFromFirestore(
                              userId: asdUserCredentials!.userId);

                      resumeTemp.setAutismChallengeList = await AutismChallenge
                          .readAllAutismChallengeDataFromFirestore(
                              userId: asdUserCredentials!.userId);

                      // Read the job preference data
                      userJobPreferenceList = await JobPreference
                          .readAllJobPreferenceDataFromFirestore(
                        userId: asdUserCredentials!.userId,
                      );
                    }

                    userResume = resumeTemp;
                  } else {
                    developer.log('Document does not exist on the database',
                        name:
                            'determine_user_type_screen=>checkUserTypeAndGetUserCredentials');
                  }
                });
              }
            } on FirebaseException catch (e) {
              developer.log(e.message.toString(),
                  name:
                      'determine_user_type_screen=>checkUserTypeAndGetUserCredentials');
            }
          } else {
            // Fetch employer user credentials
            String userId;
            String userEmail;
            bool isFirstTimeIn;

            // Fetch user id and email from firebaseAuth
            try {
              final user = _auth.currentUser;
              if (user != null) {
                userEmail = user.email!;
                userId = user.uid;

                // Once fetch id success, Fetch user name from firebaseAuth
                await _firestore
                    .collection('recruiter_users')
                    .doc(userId)
                    .get()
                    .then((DocumentSnapshot documentSnapshot) async {
                  if (documentSnapshot.exists) {
                    Map<String, dynamic> data =
                        documentSnapshot.data() as Map<String, dynamic>;
                    isFirstTimeIn = data['isFirstTimeIn'];

                    // store credential into the RecruiterUserCredentials class
                    recruiterUserCredentials = RecruiterUserCredentials(
                      userId: userId,
                      userEmail: userEmail,
                      isFirstTimeIn: isFirstTimeIn,
                    );

                    RecruiterProfile? recruiterProfileTemp = RecruiterProfile(
                      userId: userId,
                      profileImage: null,
                      profileImageUrl: null,
                      firstName: null,
                      lastName: null,
                      companyName: null,
                      jobTitle: null,
                    );

                    RecruiterCompanyInfo? recruiterCompanyInfoTemp =
                        RecruiterCompanyInfo(
                      userId: userId,
                      companyLogoImage: null,
                      companyLogoImageUrl: null,
                      companyName: null,
                      companyMinSize: null,
                      companyMaxSize: null,
                      companyAddress: null,
                      companyDescription: null,
                    );

                    if (!isFirstTimeIn) {
                      try {
                        recruiterProfileTemp = await RecruiterProfile
                            .readRecruiterProfileDataFromFirestore(userId);
                        recruiterCompanyInfoTemp = await RecruiterCompanyInfo
                            .readRecruiterCompanyInfoFromFirestore(userId);
                      } on FirebaseException catch (e) {
                        Utils.showSnackBar(
                          e.message,
                          kErrorIcon,
                        );
                      }
                    }

                    recruiterProfile = recruiterProfileTemp;
                    recruiterCompanyInfo = recruiterCompanyInfoTemp;
                  } else {
                    developer.log('Document does not exist on the database',
                        name:
                            'determine_user_type_screen=>checkUserTypeAndGetUserCredentials');
                  }
                });
              }
            } on FirebaseException catch (e) {
              developer.log(e.message.toString(),
                  name:
                      'determine_user_type_screen=>checkUserTypeAndGetUserCredentials');
            }
          }
        }
      });
    } on FirebaseException catch (e) {
      developer.log(e.message.toString(),
          name:
              'determine_user_type_screen=>checkUserTypeAndGetUserCredentials');
    }
  }

  Future? myFutureTicket;

  @override
  void initState() {
    super.initState();
    myFutureTicket = fetchUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: myFutureTicket,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: SafeArea(
                  child: Column(
                children: const [Text('Something went wrong')],
              )),
            );
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return Scaffold(
              body: SafeArea(
                  child: Column(
                children: const [Text('Document does not exist')],
              )),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (userType == 'JobSeeker') {
              if (asdUserCredentials!.isFirstTimeIn) {
                return AsdPersonalDetailsScreen(
                  asdUserCredentials: asdUserCredentials!,
                  userResume: userResume!,
                  isFirstTimeIn: asdUserCredentials!.isFirstTimeIn,
                );
              } else {
                return AsdHomeScreen(
                  asdUserCredentials: asdUserCredentials!,
                  userJobPreferenceList: userJobPreferenceList!,
                  userResume: userResume!,
                );
              }
            } else {
              if (recruiterUserCredentials!.isFirstTimeIn) {
                return RecruiterProfileScreen(
                  recruiterUserCredentials: recruiterUserCredentials!,
                  recruiterProfile: recruiterProfile!,
                  recruiterCompanyInfo: recruiterCompanyInfo!,
                );
              } else {
                return RecruiterHomeScreen(
                  recruiterUserCredentials: recruiterUserCredentials!,
                  recruiterProfile: recruiterProfile!,
                  recruiterCompanyInfo: recruiterCompanyInfo!,
                );
              }
            }
          }
          // TODO: make a skeleton UI for loading
          return const Scaffold(
            body: SafeArea(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        });
  }
}
