import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'package:autism_bridge/misc/SignedEmployerHomeScreen.dart';
import 'package:autism_bridge/misc/Employer.dart';

import 'package:autism_bridge/misc/ImageWidget.dart';

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
    Employer signedEmployer = routeArgs['signedEmployer'] as Employer;

    // Go back to Main Page for Signed Employer User
    await Navigator.of(ctx).popAndPushNamed(
      SignedEmployerHomeScreen.routeName,
      arguments: {
        'signedEmployer': signedEmployer,
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
