import 'package:autism_bridge/screens/asd_email_verify_screen.dart';
import 'package:autism_bridge/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class IsLogIn extends StatelessWidget {
  static const id = 'is_log_in';

  const IsLogIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              // TODO: Test the UI
              child: Text('Something went wrong'),
            );
          } else if (snapshot.hasData) {
            // snapshot.hasData means there is a user logged in

            return const AsdEmailVerifyScreen();

            // await FirebaseFirestore.instance
            //     .collection('all_users')
            //     .doc(snapshot.data!.uid)
            //     .get()
            //     .then((DocumentSnapshot documentSnapshot) {
            //   if (documentSnapshot.exists) {
            //     Map<String, dynamic> data =
            //         documentSnapshot.data() as Map<String, dynamic>;
            //     final String userType = data['wantedJobTitle'];
            //
            //     if (userType == 'JobSeeker') {
            //       return const AsdEmailVerifyScreen();
            //     } else if (userType == 'Employer') {
            //       // TODO: return to Employer's side, below is for testing
            //       return const JoinInEmployerPage();
            //     }
            //   }
            // });
            //
            // return Utils.showSnackBar(
            //   'Something went wrong',
            //   const Icon(
            //     Icons.error_sharp,
            //     color: Colors.red,
            //     size: 30.0,
            //   ),
            // );
            // //return const JoinInEmployerPage();
          } else {
            return const WelcomeScreen();
          }
        });
  }
}
