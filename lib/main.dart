import 'package:autism_bridge/screens/email_verify_screen.dart';
import 'package:autism_bridge/screens/determine_user_type_loading_screen.dart';
import 'package:autism_bridge/screens/welcome_screen.dart';
import 'package:autism_bridge/widgets/is_log_in.dart';
import 'package:flutter/material.dart';
import 'package:autism_bridge/widgets/dismiss_keyboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'widgets/utils.dart';
import 'package:sizer/sizer.dart';
import 'package:autism_bridge/misc/SignedEmployerSettingsScreen.dart';

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
              //SignedEmployerHomeScreen.routeName: (context) =>SignedEmployerHomeScreen(),
              // EmployerProfilePage.routeName: (context) =>
              //     const EmployerProfilePage(),
              EmployerSettingsScreen.routeName: (context) =>
                  const EmployerSettingsScreen(),
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
