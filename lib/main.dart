import 'dart:io';

import 'package:autism_bridge/screens/asd_autism_challenges_screen.dart';
import 'package:autism_bridge/screens/asd_education_screen.dart';
import 'package:autism_bridge/screens/email_verify_screen.dart';
import 'package:autism_bridge/screens/asd_employment_history_screen.dart';
import 'package:autism_bridge/screens/asd_home_screen.dart';
import 'package:autism_bridge/screens/login_screen.dart';
import 'package:autism_bridge/screens/asd_personal_details_screen.dart';
import 'package:autism_bridge/screens/asd_professional_summary_screen.dart';
import 'package:autism_bridge/screens/asd_resume_builder_screen.dart';
import 'package:autism_bridge/screens/signup_screen.dart';
import 'package:autism_bridge/screens/asd_skills_screen.dart';
import 'package:autism_bridge/screens/determine_user_type_loading_screen.dart';
import 'package:autism_bridge/screens/welcome_screen.dart';
import 'package:autism_bridge/widgets/is_log_in.dart';
import 'package:flutter/material.dart';
import 'package:autism_bridge/widgets/dismiss_keyboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'widgets/utils.dart';
import 'package:sizer/sizer.dart';

import 'package:autism_bridge/screens/SignInEmployerScreen.dart';
import 'package:autism_bridge/screens/JoinInEmployerScreen.dart';
import 'package:autism_bridge/screens/JoinInEmployerScreen2.dart';
import 'package:autism_bridge/screens/SignedEmployerHomeScreen.dart';
import 'package:autism_bridge/screens/SignedEmployerMessagingScreen.dart';
import 'package:autism_bridge/screens/SignedEmployerNewMessageScreen.dart';
import 'package:autism_bridge/screens/SignedEmployerProfileScreen.dart';
import 'package:autism_bridge/screens/SignedEmployerSettingsScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const AutismBridgeApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class AutismBridgeApp extends StatelessWidget {
  const AutismBridgeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Sizer(
        builder: (BuildContext context, Orientation orientation,
            DeviceType deviceType) {
          return MaterialApp(
            // /// One small problem of this responsive wrapper is the background is shown
            // /// before the main screen (using sizer package is a better solution).
            // builder: (context, widget) => ResponsiveWrapper.builder(
            //   ClampingScrollWrapper.builder(context, widget!),
            //   maxWidth: 1200,
            //   minWidth: 480,
            //   defaultScale: true,
            //   breakpoints: [
            //     const ResponsiveBreakpoint.resize(480, name: MOBILE),
            //     const ResponsiveBreakpoint.autoScale(800, name: TABLET),
            //     const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
            //   ],
            //   background: Container(color: const Color(0xFFF8F9FA)),
            // ),
            scaffoldMessengerKey: Utils.messengerKey,
            navigatorKey: navigatorKey,
            theme: ThemeData(
              fontFamily: 'Poppins',
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              platform: TargetPlatform.iOS,
            ),
            initialRoute: IsLogIn.id,
            routes: {
              DetermineUserTypeLoadingScreen.id: (context) =>
                  const DetermineUserTypeLoadingScreen(),
              IsLogIn.id: (context) => const IsLogIn(),
              '/': (context) => const WelcomeScreen(),
              WelcomeScreen.id: (context) => const WelcomeScreen(),
              // LoginScreen.id: (context) => const LoginScreen(),
              // AsdSignupScreen.id: (context) => const AsdSignupScreen(),
              EmailVerifyScreen.id: (context) => const EmailVerifyScreen(),
              //AsdHomeScreen.id: (context) => const AsdHomeScreen(),
              SignInEmployerPage.nameRoute: (context) =>
                  const SignInEmployerPage(),
              JoinInEmployerPage.nameRoute: (context) =>
                  const JoinInEmployerPage(),
              JoinInEmployerSecondPage.nameRoute: (context) =>
                  const JoinInEmployerSecondPage(),
              //SignedEmployerHomeScreen.routeName: (context) =>SignedEmployerHomeScreen(),
              // EmployerProfilePage.routeName: (context) =>
              //     const EmployerProfilePage(),
              EmployerSettingsScreen.routeName: (context) =>
                  const EmployerSettingsScreen(),
              EmployerMessagingScreen.nameRoute: (context) =>
                  const EmployerMessagingScreen(),
              EmployerSendNewMessageScreen.routeName: (context) =>
                  const EmployerSendNewMessageScreen(),
              // AsdResumeBuilderScreen.id: (context) =>
              //     const AsdResumeBuilderScreen(),
              // AsdPersonalDetailsScreen.id: (context) =>
              //     const AsdPersonalDetailsScreen(),
              // AsdProfessionalSummaryScreen.id: (context) =>
              //     const AsdProfessionalSummaryScreen(),
              // AsdEmploymentHistoryScreen.id: (context) =>
              //     const AsdEmploymentHistoryScreen(),
              // AsdEducationScreen.id: (context) => const AsdEducationScreen(),
              // AsdSkillsScreen.id: (context) => const AsdSkillsScreen(),
              // AsdChallengesScreen.id: (context) => const AsdChallengesScreen(),
            },
          );
        },
      ),
    );
  }
}
