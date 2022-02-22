import 'package:autism_bridge/constants.dart';
import 'package:autism_bridge/screens/SignInEmployerScreen.dart';
import 'package:autism_bridge/screens/SignedEmployerHomeScreen.dart';
import 'package:autism_bridge/screens/asd_home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetermineUserTypeLoadingScreen extends StatefulWidget {
  static const id = 'determine_user_type_screen';
  const DetermineUserTypeLoadingScreen({Key? key}) : super(key: key);

  @override
  _DetermineUserTypeLoadingScreenState createState() =>
      _DetermineUserTypeLoadingScreenState();
}

class _DetermineUserTypeLoadingScreenState
    extends State<DetermineUserTypeLoadingScreen> {
  String? userType;

  Future<void> checkUserType() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('all_users')
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        userType = data['userType'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: checkUserType(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (userType == 'JobSeeker') {
              return const AsdHomeScreen();
            } else {
              //TODO: change this when billy finish the SignedInEmployerHomeScreen arch rebuild
              return const AsdHomeScreen();
            }
          } else {
            return const Center(
              child: Scaffold(
                backgroundColor: kBackgroundRiceWhite,
                body: Center(
                  child: CupertinoActivityIndicator(),
                ),
              ),
            );
          }
        });
  }
}
