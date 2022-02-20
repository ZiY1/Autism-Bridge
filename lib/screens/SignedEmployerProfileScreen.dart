import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:autism_bridge/screens/SignedEmployerHomeScreen.dart';

import 'package:autism_bridge/widgets/ImageWidget.dart';

import 'package:autism_bridge/widgets/ConnectionsNumberWidget.dart';

class EmployerProfilePage extends StatefulWidget {
  static String routeName = "EmployerProfilePage";

  const EmployerProfilePage({Key? key}) : super(key: key);

  @override
  _EmployerProfilePageState createState() => _EmployerProfilePageState();
}

class _EmployerProfilePageState extends State<EmployerProfilePage> {
  //
  // Function that takes Navigator back to the Main Page
  void goBackToMainPage(BuildContext ctx) async {
    // TODO: Send the update it info in case there was an update
    // Gather the UserInfo and send it back to the previous navigator page
    final routeArgs =
        ModalRoute.of(ctx)?.settings.arguments as Map<String, dynamic>;

    String userFirstName = routeArgs['userFirstName'] as String;
    String userLastName = routeArgs['userLastName'] as String;
    String userEmail = routeArgs['userEmail'] as String;
    String userId = routeArgs['userId'] as String;
    int userNewMessages = routeArgs['userNewMessages'] as int;
    String userUrlProfilePicture = "";

    // Check if there was a change in the userUrlProfilePicture
    await FirebaseFirestore.instance
        .collection("EmployerUsers")
        .doc(userId)
        .get()
        .then((value) {
      Map<String, dynamic> data = value.data() as Map<String, dynamic>;
      setState(() {
        userUrlProfilePicture = data['urlProfileImage'] as String;
      });
    });

    // Go back to Main Page for Signed Employer User
    await Navigator.of(ctx).popAndPushNamed(
      SignedEmployerHomeScreen.routeName,
      arguments: {
        'userFirstName': userFirstName,
        'userLastName': userLastName,
        'userEmail': userEmail,
        'userId': userId,
        'userNewMessages': userNewMessages,
        'userUrlProfilePicture': userUrlProfilePicture,
      },
    );
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

      // Gather the user arguments
      final routeArgs =
          ModalRoute.of(ctx)?.settings.arguments as Map<String, dynamic>;

      // Get the userId
      String userId = routeArgs['userId'] as String;

      // Get access to the FirebaseStorage's folder 'user_images' and
      // map it to that user_Id
      final ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child("user_images/")
          .child("${userId}.jpg");

      // Put that image file with the respective user Id
      await ref.putFile(pickedImageFile);

      // Get the url of the profile image of the user
      final userImageUrl = await ref.getDownloadURL();

      // update the info in the database
      FirebaseFirestore.instance.collection("EmployerUsers").doc(userId).update(
        {
          'urlProfileImage': userImageUrl.toString(),
        },
      );

      // Show the change of images to the user
      setState(() => imageSelected = pickedImageFile);
    } on PlatformException catch (e) {
      // TODO: ...
      print('Failed to pick the image $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getProfilePageAppBar(
        context,
        goBackToMainPage,
      ),
      body: getProfilePageBody(
        context,
        pickImage,
        imageSelected,
      ),
    );
  }
}

AppBar getProfilePageAppBar(BuildContext ctx, Function goBackToMainPage) {
  return AppBar(
    backgroundColor: Colors.blue.shade900,
    leading: IconButton(
      onPressed: () {
        goBackToMainPage(ctx);
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
) {
  // Calculate Device's Dimension
  final textScaleFactor = MediaQuery.of(ctx).textScaleFactor;
  final screenDeviceHeight = MediaQuery.of(ctx).size.height;
  //final screenDeviceWidth = MediaQuery.of(ctx).size.width;

  // Get the user Info
  final routeArgs =
      ModalRoute.of(ctx)?.settings.arguments as Map<String, dynamic>;

  String userFirstName = routeArgs['userFirstName'] as String;
  String userLastName = routeArgs['userLastName'] as String;
  String userEmail = routeArgs['userEmail'] as String;
  String userUrlProfilePicture = routeArgs['userUrlProfilePicture'] as String;

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
