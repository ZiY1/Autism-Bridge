import 'package:autism_bridge/models/asd_user_credentials.dart';
import 'package:autism_bridge/screens/SignedEmployerHomeScreen.dart';
import 'package:autism_bridge/screens/asd_home_screen.dart';
import 'package:autism_bridge/screens/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:autism_bridge/models/Employer.dart';

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

  Employer? employer;

  Future<void> checkUserType() async {
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
            String userFirstName;
            String userLastName;

            // Fetch user id and email from firebaseAuth
            try {
              final user = _auth.currentUser;
              if (user != null) {
                userEmail = user.email!;
                userId = user.uid;

                // Once fetch id success, Fetch user name from firebaseAuth
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

                    // store credential into the AsdUserCredentials class
                    asdUserCredentials = AsdUserCredentials(
                        userId: userId,
                        userEmail: userEmail,
                        userFirstName: userFirstName,
                        userLastName: userLastName);
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
            // TODO: Fetch Employer user credentials

            // Fetch employer user credentials
            String userId;
            String userUrlProfilePicture;
            String userFirstName;
            String userLastName;
            String userEmail;
            String userPassword;
            int userNewMessages;

            // Fetch user id and email from firebaseAuth
            try {
              final user = _auth.currentUser;
              if (user != null) {
                userEmail = user.email!;
                userId = user.uid;

                // Once fetch id success, Fetch user name from firebaseAuth
                await _firestore
                    .collection('EmployerUsers')
                    .doc(userId)
                    .get()
                    .then((DocumentSnapshot documentSnapshot) {
                  if (documentSnapshot.exists) {
                    Map<String, dynamic> data =
                        documentSnapshot.data() as Map<String, dynamic>;
                    userFirstName = data['userFirstName'];
                    userLastName = data['userLastName'];
                    userUrlProfilePicture = data['urlProfileImage'];
                    userPassword = data['userPassword'];
                    userNewMessages = data['userNewMessages'];

                    // store credential into the Employer class
                    employer = Employer(
                        userId: userId,
                        userUrlProfilePicture: userUrlProfilePicture,
                        userFirstName: userFirstName,
                        userLastName: userLastName,
                        userEmail: userEmail,
                        userPassword: userPassword,
                        userNewMessages: userNewMessages);
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: checkUserType(),
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
              return AsdHomeScreen(
                asdUserCredentials: asdUserCredentials!,
              );
            } else {
              //TODO: change this when billy finish the SignedInEmployerHomeScreen arch rebuild
              return SignedEmployerHomeScreen(employer: employer!);
            }
          }
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
