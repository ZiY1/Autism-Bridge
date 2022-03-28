import 'dart:async';
import 'package:autism_bridge/color_constants.dart';
import 'package:autism_bridge/screen_transition_animation/screen_transition_animation.dart';
import 'package:autism_bridge/screens/determine_user_type_loading_screen.dart';
import 'package:autism_bridge/screens/welcome_screen.dart';
import 'package:autism_bridge/widgets/registration_button.dart';
import 'package:autism_bridge/widgets/registration_title.dart';
import 'package:autism_bridge/widgets/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class EmailVerifyScreen extends StatefulWidget {
  static const id = 'email_verify_screen';

  const EmailVerifyScreen({Key? key}) : super(key: key);

  @override
  State<EmailVerifyScreen> createState() => _EmailVerifyScreenState();
}

class _EmailVerifyScreenState extends State<EmailVerifyScreen> {
  final _auth = FirebaseAuth.instance;

  late final User currentUser;

  bool isEmailVerified = false;

  bool canResendEmail = false;

  Timer? timerCheckVerify;

  Timer? timerCountdown;

  // TODO: change maxSeconds to 60 for production
  static const maxSeconds = 10;

  int seconds = maxSeconds;

  @override
  void initState() {
    super.initState();

    getCurrentUser();

    // user needs to be created before!
    isEmailVerified = currentUser.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      // Check every three seconds
      timerCheckVerify = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timerCheckVerify?.cancel();

    timerCountdown?.cancel();

    super.dispose();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        currentUser = user;
      }
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(
        e.message,
        const Icon(
          Icons.error_sharp,
          color: Colors.red,
          size: 30.0,
        ),
      );
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = _auth.currentUser!;
      await user.sendEmailVerification();
      Utils.showSnackBar(
        'A verification email has been sent to your email. Follow the email link to verify your email.',
        const Icon(
          Icons.mark_email_read_sharp,
          color: Colors.green,
          size: 30.0,
        ),
      );

      // Disable the the resend button
      setState(() {
        canResendEmail = false;
      });
      // start countdown
      resetTimer();
      startTimer();
      // Wait for seconds
      await Future.delayed(const Duration(seconds: maxSeconds));
      // Enable the resend button
      if (!mounted) return;

      setState(() {
        canResendEmail = true;
      });
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        canResendEmail = true;
      });
      Utils.showSnackBar(
        e.message,
        const Icon(
          Icons.error_sharp,
          color: Colors.red,
          size: 30.0,
        ),
      );
    }
  }

  Future checkEmailVerified() async {
    // call after email verification
    if (_auth.currentUser != null) {
      await _auth.currentUser!.reload();
    }

    isEmailVerified = _auth.currentUser!.emailVerified;

    if (isEmailVerified) {
      timerCountdown?.cancel();
      timerCheckVerify?.cancel();

      Navigator.pushNamedAndRemoveUntil(
          context, DetermineUserTypeLoadingScreen.id, (route) => false);
    }
  }

  void startTimer() {
    timerCountdown = Timer.periodic(const Duration(seconds: 1), (_) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        timerCountdown?.cancel();
      }
    });
  }

  void resetTimer() {
    setState(() {
      seconds = maxSeconds;
    });
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const DetermineUserTypeLoadingScreen()
      : Scaffold(
          backgroundColor: const Color(0xFFF0F0F2),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 1.7.h, right: 1.7.h, top: 4.4.h),
              child: Column(
                children: [
                  RegistrationTitle(
                    title: 'Verify Your Email',
                    subtitle:
                        'A verification email has been sent to \n${currentUser.email} \nClick the link, and you\'ll be logged in',
                    backOnPressed: null,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 1.5.h, right: 1.5.h, top: 1.5.h, bottom: 4.5.h),
                    child: RegistrationButton(
                      greyBtn: !canResendEmail,
                      icon: const Icon(
                        Icons.email_sharp,
                        color: Colors.white,
                      ),
                      onPressed: canResendEmail ? sendVerificationEmail : null,
                      child: Text(
                        canResendEmail
                            ? 'Resend Email'
                            : 'Resend Email ($seconds)',
                        style: TextStyle(
                          fontSize: 12.5.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 1.5.h, right: 1.5.h, top: 1.5.h),
                    child: RegistrationButton(
                      secondaryBtn: true,
                      greyBtn: false,
                      icon: const Icon(
                        Icons.cancel_sharp,
                        color: kDarkTextGrey,
                      ),
                      onPressed: () {
                        _auth.signOut();
                        Navigator.of(context).pushAndRemoveUntil(
                            ScreenTransitionAnimation.createBackRoute(
                                destScreen: const WelcomeScreen()),
                            (route) => false);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 12.5.sp,
                          color: kDarkTextGrey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ));
}
