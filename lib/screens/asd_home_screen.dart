import 'package:autism_bridge/models/autism_challenge_data.dart';
import 'package:autism_bridge/models/education_data.dart';
import 'package:autism_bridge/models/employment_history_data.dart';
import 'package:autism_bridge/models/personal_details_data.dart';
import 'package:autism_bridge/models/professional_summary_data.dart';
import 'package:autism_bridge/models/skill_data.dart';
import 'package:autism_bridge/screens/asd_job_preference_screen.dart';
import 'package:autism_bridge/screens/asd_resume_builder_screen.dart';
import 'package:autism_bridge/screens/welcome_screen.dart';
import 'package:autism_bridge/widgets/date_time_picker_widget.dart';
import 'package:autism_bridge/widgets/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final _firestore = FirebaseFirestore.instance;

class AsdHomeScreen extends StatefulWidget {
  static const id = 'asd_home_screen';

  const AsdHomeScreen({Key? key}) : super(key: key);

  @override
  State<AsdHomeScreen> createState() => _AsdHomeScreenState();
}

class _AsdHomeScreenState extends State<AsdHomeScreen> {
  final _auth = FirebaseAuth.instance;

  String? userFirstName;

  String? userLastName;

  String? userEmail;

  String? userId;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        userEmail = user.email!;
        userId = user.uid;
        getUsername();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getUsername() async {
    await _firestore
        .collection('all_users')
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        userFirstName = data['firstName'];
        userLastName = data['lastName'];
        //print(userFirstName);
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: getUsername(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  Text(userEmail!),
                  Text(userId!),
                  Text('$userFirstName $userLastName'),
                  ElevatedButton(
                    onPressed: () {
                      _auth.signOut();
                      Navigator.pushNamedAndRemoveUntil(
                          context, WelcomeScreen.id, (route) => false);
                    },
                    child: const Text('Sign Out'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      PersonalDetails? userPersonalDetails =
                          await PersonalDetails
                              .readPersonalDetailsDataFromFirestore(userId!);

                      ProfessionalSummary? userProfessionalSummary =
                          await ProfessionalSummary
                              .readProfessionalSummaryDataFromFirestore(
                                  userId!);

                      // try to read cv_employment_history of current users' subcollection employment_histories in firestore
                      // Store it/them in List<EmploymentHistory?> userEmploymentHistory
                      // Two Cases:
                      // 1. has no data, so userEmploymentHistory has a list of null
                      // 2. has data, so userEmploymentHistory has a list of EmploymentHistory obj

                      List<EmploymentHistory?> userEmploymentHistoryList =
                          await EmploymentHistory
                              .readAllEmploymentHistoryDataFromFirestore(
                                  userId: userId!);

                      List<Education?> userEducationList =
                          await Education.readAllEducationDataFromFirestore(
                              userId: userId!);

                      List<Skill?> userSkillList =
                          await Skill.readAllSkillDataFromFirestore(
                              userId: userId!);

                      List<AutismChallenge?> userAutismChallengeList =
                          await AutismChallenge
                              .readAllAutismChallengeDataFromFirestore(
                                  userId: userId!);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AsdResumeBuilderScreen(
                            userFirstName: userFirstName!,
                            userLastName: userLastName!,
                            userEmail: userEmail!,
                            userId: userId!,
                            userPersonalDetails: userPersonalDetails,
                            userProfessionalSummary: userProfessionalSummary,
                            userEmploymentHistoryList:
                                userEmploymentHistoryList,
                            userEducationList: userEducationList,
                            userSkillList: userSkillList,
                            userAutismChallengeList: userAutismChallengeList,
                          ),
                        ),
                      );
                    },
                    child: const Text('Resume Builder'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AsdJobPreferenceScreen(
                            userFirstName: userFirstName!,
                            userLastName: userLastName!,
                            userEmail: userEmail!,
                            userId: userId!,
                          ),
                        ),
                      );
                    },
                    child: const Text('Job Preference'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Utils.showProgressIndicator(context);
                    },
                    child: const Text('Progress Indicator Test'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DateTimePicker(),
                        ),
                      );
                    },
                    child: const Text('Date Time Test'),
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

// class GetUserName extends StatelessWidget {
//   final String documentId;
//
//   const GetUserName(this.documentId);
//
//   @override
//   Widget build(BuildContext context) {
//     CollectionReference users =
//         FirebaseFirestore.instance.collection('asd_users');
//
//     return FutureBuilder<DocumentSnapshot>(
//       future: users.doc(documentId).get(),
//       builder:
//           (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//         if (snapshot.hasError) {
//           return const Text("Something went wrong");
//         }
//
//         if (snapshot.hasData && !snapshot.data!.exists) {
//           return const Text("Document does not exist");
//         }
//
//         if (snapshot.connectionState == ConnectionState.done) {
//           Map<String, dynamic> data =
//               snapshot.data!.data() as Map<String, dynamic>;
//           return Text("Full Name: ${data['name']}");
//         }
//
//         return const Text("loading");
//       },
//     );
//   }
// }
