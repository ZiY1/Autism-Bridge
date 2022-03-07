import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:autism_bridge/models/Employer.dart';
import 'package:autism_bridge/screens/SignedEmployerHomeScreen.dart';

import 'package:autism_bridge/widgets/ImageWidget.dart';

import 'package:autism_bridge/widgets/ConnectionsNumberWidget.dart';

class EmployerProfilePage extends StatefulWidget {
  static String routeName = "EmployerProfilePage";

  final Employer employer;

  const EmployerProfilePage({Key? key, required this.employer,}) : super(key: key);

  @override
  _EmployerProfilePageState createState() => _EmployerProfilePageState();
}

class _EmployerProfilePageState extends State<EmployerProfilePage> {
  //
  // Function that takes Navigator back to the Main Page
  void goBackToMainPage(BuildContext ctx, Employer signedEmployer) async {
    // TODO: Send the update it info in case there was an update

    // Gather the UserInfo and send it back to the previous navigator page
    String userId = signedEmployer.id;

    // Check if there was a change in the userUrlProfilePicture
    await FirebaseFirestore.instance
        .collection("EmployerUsers")
        .doc(userId)
        .get()
        .then((value) {
      Map<String, dynamic> data = value.data() as Map<String, dynamic>;
      setState(() {
        signedEmployer.urlProfilePicture = data['urlProfileImage'] as String;
      });
    });

    // Go back to Main Page for Signed Employer User
    // Navigator.of(ctx).popAndPushNamed(
    //   SignedEmployerHomeScreen.routeName,
    //   arguments: {
    //     'signedEmployer': signedEmployer,
    //   },
    // );
    Navigator.pop(context, signedEmployer);
  }

  File? imageSelected;
  Future pickImage(
    ImageSource imageSource,
    BuildContext ctx,
  ) async {
    try {
      // Let user pick an image from gallery or camera
      var pickedImage = await ImagePicker().pickImage(
        source: imageSource,
        maxHeight: 160,
        maxWidth: 160,
      );

      // Cast it as a File object
      File pickedImageFile = File(pickedImage!.path);

      
      // Change the urlProfilePicture in the data base
      widget.employer.changeUrlProfilePicture(pickedImageFile);

      // Show the change of images to the user
      setState(() => imageSelected = pickedImageFile);
    } on PlatformException catch (e) {
      // TODO: ...
      print('Failed to pick the image $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Gather the user arguments
    /*final routeArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    */

    //Employer signedEmployer = routeArgs['signedEmployer'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getProfilePageAppBar(
        context,
        goBackToMainPage,
        widget.employer,
      ),
      body: getProfilePageBody(
        context,
        pickImage,
        imageSelected,
        widget.employer,
      ),
    );
  }
}

AppBar getProfilePageAppBar(
  BuildContext ctx,
  Function goBackToMainPage,
  Employer signedEmployer,
) {
  return AppBar(
    backgroundColor: Colors.blue.shade900,
    leading: IconButton(
      onPressed: () {
        goBackToMainPage(ctx, signedEmployer);
      },
      icon: Icon(
        Icons.arrow_back,
        color: Colors.white,
      ),
    ),
    centerTitle: true,
    title: Text(
      "My Profile Page",
      style: TextStyle(
        color: Colors.white,
      ),
    ),
  );
}

Widget getProfilePageBody(
  BuildContext ctx,
  Function pickImage,
  File? image,
  Employer signedEmployer,
) {
  // Calculate Device's Dimension
  final textScaleFactor = MediaQuery.of(ctx).textScaleFactor;
  final screenDeviceHeight = MediaQuery.of(ctx).size.height;

  // Get the user Info
  String userFirstName = signedEmployer.firstName;
  String userLastName = signedEmployer.lastName;
  String userEmail = signedEmployer.email;
  String userUrlProfilePicture = signedEmployer.urlProfilePicture;

  Widget userFullNameText = Text(
    "$userFirstName $userLastName",
    style: TextStyle(
      fontSize: textScaleFactor * 30,
      backgroundColor: Colors.white,
      color: Colors.blue.shade900,
      fontWeight: FontWeight.bold,
    ),
  );

  Widget userEmailText = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        padding: const EdgeInsets.only(right: 5),
        child: Icon(
          Icons.email,
          color: Colors.blueGrey.shade500,
        ),
      ),
      Text(
        userEmail,
        style: TextStyle(
          fontSize: textScaleFactor * 20,
          backgroundColor: Colors.white,
          color: Colors.blueGrey.shade500,
          fontWeight: FontWeight.bold,
        ),
      )
    ],
  );

  return Column(
    children: <Widget>[
      Container(
        color: Colors.white,
        padding: EdgeInsets.only(
          top: 0.04 * screenDeviceHeight,
        ),
        child: image != null
            ? ImageWidget(
                image: image,
                onClicked: (ImageSource source, BuildContext context) =>
                    pickImage(source, context),
              )
            : ProfilePictureWidget(
                userUrlProfilePicture: userUrlProfilePicture,
                onClicked: pickImage,
              ),
      ),
      Container(
        padding: const EdgeInsets.only(
          top: 10,
        ),
        child: userFullNameText,
      ),
      Container(
        padding: const EdgeInsets.only(top: 10),
        child: userEmailText,
      ),
      Container(
        padding: const EdgeInsets.only(top: 10),
        child: ConnectionsNumberWidget(
          // TODO: Make it dynamic according with each user
          numberOfPosts: "50",
        ),
      ),
      Container(
        padding: EdgeInsets.only(
          top: 10,
        ),
        child:
            aboutWidget("Certified Recruiter at CCNY looking for candidates"),
      ),
    ],
  );
}

Widget aboutWidget(String userAbout) {
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: 48,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          "About",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.black,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          userAbout,
          style: TextStyle(
            fontSize: 16,
            height: 1.7,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    ),
  );
}
