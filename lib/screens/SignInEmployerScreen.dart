import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:autism_bridge/screens/login_screen.dart';

import 'package:autism_bridge/screens/JoinInEmployerScreen.dart';
import 'package:autism_bridge/screens/SignedEmployerHomeScreen.dart';

import 'package:autism_bridge/widgets/emailFieldWidget.dart';
import 'package:autism_bridge/widgets/passwordFieldWidget.dart';

import 'email_verify_screen.dart';

class SignInEmployerPage extends StatefulWidget {
  static String nameRoute = '/Sign_In_Page?';

  const SignInEmployerPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignInEmployerPageState();
}

class _SignInEmployerPageState extends State<SignInEmployerPage> {
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

  // Variables for storing user's credentials
  String userEmailInput = "";
  String userPasswordInput = "";

  // Controller text variable for clearing the text field
  // and updating the state
  final fieldText = TextEditingController();
  void clearTextField() {
    setState(() {
      fieldText.clear();
    });
  }

  // Function that tells Navigator to go back to Main Page
  void goBackHome(BuildContext ctx) {
    Navigator.of(ctx).popAndPushNamed(
      '/',
      arguments: null,
    );
  }

  // Function that tells Navigator to go to "Join Page"
  void goToJoinInPage(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      JoinInEmployerPage.nameRoute,
      arguments: null,
    );
  }

  // Loading state to show while trying to verify Sign In
  bool _isloading = false;

  // Function that Sign-in the user
  void goToMyAccount(BuildContext ctx) async {
    final emailForm = emailFormKey.currentState!;
    final passwordForm = passwordFormKey.currentState!;

    if (emailForm.validate() && passwordForm.validate()) {
      //
      // Show a Loading screen while processing the request
      setState(() {
        _isloading = true;
      });

      // Get the email and password from the user
      String userEmail = emailController.text;
      String userPassword = passwordController.text;

      // Try loggin in the user
      try {
        // Check if the credentials match with the database's record
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userEmail,
          password: userPassword,
        );

        // Get the user Id
        String userId = userCredential.user!.uid;

        // Use the email Id to gather the rest of the
        // user info (e.g name, last name, profile picture, new messages, etc)
        // Only Employer User are allowed otherwise we will trigger an error
        CollectionReference users =
            FirebaseFirestore.instance.collection("EmployerUsers");

        // List of Maps that will store user's info
        List<Map<String, dynamic>> userInfo = [];

        // Perform a where query to find the user info
        await users
            .where("userEmail", isEqualTo: userEmail)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            userInfo.add(data);
          });
        });

        // All the info that will be pass to the next Navigator Page
        final String userFirstName = userInfo[0]['userFirstName'];

        // Send the Navigator to the Employer Main Page
        //Navigator.of(ctx).popAndPushNamed(SignedEmployerHomeScreen.routeName);
        Navigator.pushNamedAndRemoveUntil(
            context, EmailVerifyScreen.id, (route) => false);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          showErrorDialog(
            errorMessage:
                "The email that you provided does not match our records",
            ctx: ctx,
          );
        } else if (e.code == 'wrong-password') {
          showErrorDialog(
            errorMessage:
                "You provided the wrong password for that user account",
            ctx: ctx,
          );
        } else {
          // No connection to the API
          showErrorDialog(
            errorMessage: "Something went wrong! Most likely you are offline",
            ctx: ctx,
          );
        }
      } catch (e) {
        // Something else went wrong, most likely we try to
        // access an empty userInfo which means the
        // account is not an Employer account
        showErrorDialog(
          errorMessage: "That account is not registered as an Employer account",
          ctx: ctx,
        );
      }
    } // If condition validation form
    //
  }

  Future showErrorDialog({
    required String errorMessage,
    required BuildContext ctx,
  }) {
    return showDialog(
      context: ctx,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: const <Widget>[
            Icon(
              Icons.dangerous,
              color: Colors.red,
            ),
            Text("An error has ocurred"),
          ],
        ),
        content: Text(errorMessage),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                setState(() {
                  _isloading = false;
                });
              },
              child: Text(
                "Okay",
                style: TextStyle(
                  color: Colors.blue.shade900,
                ),
              )),
        ],
      ),
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
        drawerEnableOpenDragGesture: true,
        body: SafeArea(
          child: Container(
            color: Colors.transparent,
            child: _isloading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(
                          top: screenDeviceHeight * 0.015,
                          left: screenDeviceWidth * 0.1,
                        ),
                        width: screenDeviceWidth,
                        child: Text(
                          "Sign in ",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.black,
                            fontSize: 30 * textScaleFactor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(left: screenDeviceWidth * 0.1),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Or",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.grey.shade700,
                                fontSize: 14 * textScaleFactor,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Go to "Join In Page"
                                goToJoinInPage(context);
                              },
                              child: Text(
                                "Join Autism Bridge",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14 * textScaleFactor,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all(
                                      Colors.blue.shade900)),
                            )
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.transparent,
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
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenDeviceWidth * 0.1,
                          vertical: screenDeviceHeight * 0.01,
                        ),
                        child: Form(
                          key: passwordFormKey,
                          child: PasswordFieldWidget(
                            controller: passwordController,
                            showHelper: false,
                            inSignInPage: true,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              left: screenDeviceWidth * 0.1,
                            ),
                            child: TextButton(
                              onPressed: () {
                                // TODO: ...
                              },
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: Colors.blue.shade900,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        color: Colors.white,
                        width: screenDeviceWidth,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenDeviceWidth * 0.1,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            goToMyAccount(context);
                          },
                          child: Text(
                            "Sign in",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 17 * textScaleFactor,
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue.shade800),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            fixedSize: MaterialStateProperty.all(Size(
                              screenDeviceWidth * 0.8,
                              screenDeviceWidth * 0.04,
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
