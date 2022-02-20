import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'package:autism_bridge/screens/SignedEmployerHomeScreen.dart';

import 'package:autism_bridge/widgets/ImageWidget.dart';

class EmployerSettingsScreen extends StatefulWidget {
  static String routeName = "ChangeSettingsPage";

  const EmployerSettingsScreen({Key? key}) : super(key: key);

  @override
  _EmployerSettingsScreenState createState() => _EmployerSettingsScreenState();
}

class _EmployerSettingsScreenState extends State<EmployerSettingsScreen> {
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
    String userUrlProfilePicture = routeArgs['userUrlProfilePicture'] as String;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: getAppBarSettings(
          context,
          goBackToMainPage,
        ),
        body: Center(
          child: Text("Settings"),
        ));
  }
}

AppBar getAppBarSettings(BuildContext ctx, Function goBackToMainPage) {
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
      "Settings",
      style: TextStyle(
        color: Colors.white,
      ),
    ),
  );
}
