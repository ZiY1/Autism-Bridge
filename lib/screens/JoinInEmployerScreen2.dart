import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:http/http.dart' as http;

//import 'package:flutter/services.dart' show rootBundle;

import 'package:path_provider/path_provider.dart';

import 'package:autism_bridge/screens/SignInEmployerScreen.dart';

import 'email_verify_screen.dart';

class JoinInEmployerSecondPage extends StatefulWidget {
  // Keep track of the name of the Page
  static String nameRoute = '/Join_In_Page2?';

  const JoinInEmployerSecondPage({Key? key}) : super(key: key);

  @override
  _JoinInEmployerSecondPageState createState() =>
      _JoinInEmployerSecondPageState();
}

class _JoinInEmployerSecondPageState extends State<JoinInEmployerSecondPage> {
  //
  // Controllers variable
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  final firstNameFormKey = GlobalKey<FormState>();
  final lastNameFormKey = GlobalKey<FormState>();

  void onListen() => setState(() {});

  late File fileImage;
  @override
  void initState() {
    super.initState();
    urlToFile();
    firstNameController.addListener(onListen);
    lastNameController.addListener(onListen);
  }

  @override
  void dispose() {
    firstNameController.removeListener(onListen);
    lastNameController.removeListener(onListen);

    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  // Keep track of the name of the Page
  static String nameRoute = '/Join_In_Page2?';

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

  Future<File> urlToFile() async {
    // Gather the blank-profile image from the network (The database)
    // and convert it into a File
    String imageUrl =
        "https://firebasestorage.googleapis.com/v0/b/autismbridge2.appspot.com/o/assets%2Fblank-person.jpg?alt=media&token=4e278ecd-728c-4d3b-8afa-4a0521c6ad1b";
    // generate random number.
    var rng = new Random();
    // get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
    // get temporary path from temporary directory.
    String tempPath = tempDir.path;
    // create a new file in temporary path with random file name.
    File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
    // call http.get method and pass imageUrl into it to get response.

    Uri uri = Uri.parse(imageUrl);
    http.Response response = await http.get(uri);
    // write bodyBytes received in response to file.
    await file.writeAsBytes(response.bodyBytes);

    // now return the file which is created with random name in
    // temporary directory and image bytes from response is written to // that file.
    fileImage = file;
    return file;
  }

  bool _isloading = false;

  Future<void> createAccount(
    BuildContext ctx,
  ) async {
    final firstNameForm = firstNameFormKey.currentState!;
    final lastNameForm = lastNameFormKey.currentState!;

    if (firstNameForm.validate() && lastNameForm.validate()) {
      // Extract the data coming from the previous page (mainly: user's credentials)
      final routeArgs =
          ModalRoute.of(ctx)?.settings.arguments as Map<String, String>;

      // Get all user's info (email, password, first name and last name)
      final userEmail = routeArgs['userEmail'] as String;
      final userPassword = routeArgs['userPassword'] as String;
      final userFirstName = firstNameController.text;
      final userLastName = lastNameController.text;
      final userType = "employer";

      // Add User Account to FireBase
      try {
        // Show a Loading screen while processing the request
        setState(() {
          _isloading = true;
        });

        await urlToFile();

        // Create Account for user
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: userEmail,
          password: userPassword,
        );

        // Log in the user with the provided account
        /*await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userEmail,
          password: userPassword,
        ); */

        // Send user Email Verification
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null && !user.emailVerified) {
          await user.sendEmailVerification();
        }

        // Get access to the FirebaseStorage's folder 'user_images' and
        // map it to the user Id
        final ref = firebase_storage.FirebaseStorage.instance
            .ref()
            .child("user_images/")
            .child("${userCredential.user!.uid}.jpg");

        // Put that image file with the respective user Id
        await ref.putFile(fileImage);

        // Get the url of the profile image of the user
        final userImageUrl = await ref.getDownloadURL();

        // Store all info of the user in the database
        await FirebaseFirestore.instance
            .collection("EmployerUsers")
            .doc(userCredential.user!.uid)
            .set(
          {
            'userEmail': userEmail,
            'userPassword': userPassword,
            'userFirstName': userFirstName,
            'userLastName': userLastName,
            'urlProfileImage': userImageUrl.toString(),
            'userNewMessages': 0,
          },
        );

        // Store all info in the database
        await FirebaseFirestore.instance
            .collection("all_users")
            .doc(userCredential.user!.uid)
            .set(
          {
            'email': userEmail,
            'firstName': userFirstName,
            'lastName': userLastName,
            'userType': "Employer",
          },
        );

        setState(() {
          _isloading = false;
        });
        // TODO: Go to Sign in Page?
        //goToSignInPage(ctx);
        // Navigate to asd email verify screen
        Navigator.pushNamedAndRemoveUntil(
          context,
          EmailVerifyScreen.id,
          (route) => false,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          // Error of multiple accounts with similar emails
          //
          showErrorDialog(
            errorMessage: "The account already exists for that email.",
            ctx: ctx,
          );
        } else {
          print(e);
          // Some Error occurred
          showErrorDialog(
            errorMessage: "Something went wrong!@@\n${e}",
            ctx: ctx,
          );
        }
      } catch (e) {
        // Some Error occurred
        showErrorDialog(
          errorMessage: "Something went wrong! ${e}",
          ctx: ctx,
        );
      }
      //
      //
    } // coming from the if statement
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
    // Variables that store the device's dimensions
    final screenDeviceWidth = MediaQuery.of(context).size.width;
    final screenDeviceHeight = MediaQuery.of(context).size.height;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Container(
        color: Colors.white,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: InkWell(
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            actions: <Widget>[],
          ),
          backgroundColor: Colors.white,
          body: _isloading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
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
                                  foregroundColor: MaterialStateProperty.all(
                                      Colors.blue.shade900)),
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
                          key: firstNameFormKey,
                          child: TextFormField(
                            controller: firstNameController,
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return 'Please provide your first name';
                              } else if (value.toString().length > 20) {
                                return 'First name cannot exceed 20 characters';
                              }
                            },
                            decoration: InputDecoration(
                              labelText: "First Name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              suffixIcon: firstNameController.text.isEmpty
                                  ? Container(
                                      width: 0,
                                    )
                                  : IconButton(
                                      onPressed: () {
                                        firstNameController.clear();
                                      },
                                      icon: Icon(Icons.close)),
                            ),
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
                          key: lastNameFormKey,
                          child: TextFormField(
                            controller: lastNameController,
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return 'Please provide your last name';
                              }
                            },
                            decoration: InputDecoration(
                                labelText: "Last Name",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                suffixIcon: lastNameController.text.isEmpty
                                    ? Container(
                                        width: 0,
                                      )
                                    : IconButton(
                                        onPressed: () {
                                          lastNameController.clear();
                                        },
                                        icon: Icon(Icons.close),
                                      )),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: screenDeviceWidth * 0.1,
                              vertical: screenDeviceHeight * 0.01,
                            ),
                            child: Text(
                              "By clicking Agree & Join, you agree to " +
                                  "AutismBridge's\nUser Agreement, Privacy Policy " +
                                  "and Cookie Policy",
                              style: TextStyle(
                                fontSize: textScaleFactor * 12,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        color: Colors.white,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: ...
                            createAccount(context);
                          },
                          child: Text(
                            "Agree & Join",
                            style: TextStyle(
                              fontSize: 17 * textScaleFactor,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
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
                            fixedSize: MaterialStateProperty.all(
                              Size(
                                screenDeviceWidth * 0.8,
                                screenDeviceWidth * 0.04,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
