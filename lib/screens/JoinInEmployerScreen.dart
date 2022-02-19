import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:autism_bridge/screens/SignInEmployerScreen.dart';

import 'package:autism_bridge/screens/JoinInEmployerScreen2.dart';

import 'package:autism_bridge/widgets/emailFieldWidget.dart';

import 'package:autism_bridge/widgets/passwordFieldWidget.dart';

class JoinInEmployerPage extends StatefulWidget {
  static String nameRoute = '/Join_In_Page?';

  const JoinInEmployerPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _JoinInEmployerPageState();
}

class _JoinInEmployerPageState extends State<JoinInEmployerPage> {
  // Keep track of the name of the Page
  static String nameRoute = '/Join_In_Page?';

  // Controller text variable for clearing the text field
  // and updating the state
  final emailFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  // Text Controller for password
  final passwordFormKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  bool showPassworldField = false;
  bool secondContinueAccess = false;
  String userEmail = "";
  void firstclickContinue(BuildContext ctx) {
    final emailForm = emailFormKey.currentState!;

    if (emailForm.validate()) {
      userEmail = emailController.text;

      setState(() {
        showPassworldField = true;
        secondContinueAccess = true;
      });

      ScaffoldMessenger.of(ctx)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text("Your email is $userEmail"),
            backgroundColor: Colors.blueGrey,
          ),
        );
    }
  }

  void secondclickContinue(BuildContext ctx) {
    final passwordForm = passwordFormKey.currentState!;
    final emailForm = emailFormKey.currentState!;

    if (passwordForm.validate() && emailForm.validate()) {
      final userPassword = passwordController.text;
      final userEmail = emailController.text;

      goToNextJoinPage(ctx, userEmail, userPassword);
    }
  }

  // Function that tells Navigator to go back to Main Page
  void goBackHome(BuildContext ctx) {
    Navigator.of(ctx).popAndPushNamed(
      '/',
      arguments: null,
    );
  }

  // Function that tells Navigator to go to "Sign In Page"
  void goToSignInPage(BuildContext ctx) {
    Navigator.of(ctx).popAndPushNamed(
      SignInEmployerPage.nameRoute,
      arguments: null,
    );
  }

  // Function that tells Navigator to go to the next Page of "Join in Page"
  void goToNextJoinPage(
      BuildContext ctx, String userEmail, String userPassword) {
    Navigator.of(ctx).restorablePushNamed(
      JoinInEmployerSecondPage.nameRoute,
      arguments: {
        'userEmail': userEmail,
        'userPassword': userPassword,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //
    // Variables that store the Device dimensions
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final screenDeviceHeight = MediaQuery.of(context).size.height;
    final screenDeviceWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Container(
            padding: EdgeInsets.only(
              right: screenDeviceWidth * 0.5,
              top: screenDeviceHeight * 0.1,
              bottom: screenDeviceHeight * 0.1,
            ),
            color: Colors.white,
            child: Image.asset("images/Autism_Bridge_Icon_Logo.png"),
          ),
          toolbarHeight: screenDeviceHeight * 0.13,
          leadingWidth: screenDeviceWidth * 0.01,
          leading: Text(""),
          elevation: 0,
          titleSpacing: 0,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: screenDeviceWidth * 0.025),
              child: IconButton(
                onPressed: () {
                  // Go back to Main Page
                  FocusManager.instance.primaryFocus?.unfocus();
                  goBackHome(context);
                },
                icon: Icon(
                  Icons.close_rounded,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
          ],
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                padding: EdgeInsets.only(
                  top: screenDeviceHeight * 0.015,
                  left: screenDeviceWidth * 0.1,
                ),
                width: screenDeviceWidth,
                child: Text(
                  "Join Autism Bridge",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: textScaleFactor * 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.only(
                  left: screenDeviceWidth * 0.1,
                ),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Or",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14 * textScaleFactor,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Go to "Sign in Page"
                        goToSignInPage(context);
                      },
                      child: Text(
                        "sign in",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14 * textScaleFactor,
                        ),
                      ),
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.blue.shade900)),
                    )
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: screenDeviceWidth * 0.1,
                  vertical: screenDeviceHeight * 0.01,
                ),
                child: Form(
                  key: emailFormKey,
                  child: EmailFieldWidget(
                    controller: emailController,
                  ),
                ),
              ),
              Container(
                child: showPassworldField
                    ? Container(
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenDeviceWidth * 0.1,
                          vertical: screenDeviceHeight * 0.01,
                        ),
                        child: Form(
                          key: passwordFormKey,
                          child: PasswordFieldWidget(
                            controller: passwordController,
                            showHelper: true,
                            inSignInPage: false,
                          ),
                        ),
                      )
                    : null,
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.only(top: screenDeviceHeight * 0.01),
                child: ElevatedButton(
                  onPressed: () {
                    secondContinueAccess
                        ? secondclickContinue(context)
                        : firstclickContinue(context);
                  },
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 17 * textScaleFactor,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blue.shade800),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    fixedSize: MaterialStateProperty.all(
                      Size(
                        screenDeviceWidth * 0.8,
                        screenDeviceWidth * 0.04,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
