import 'package:flutter/material.dart';

import 'package:autism_bridge/screens/SignedEmployerMessagingScreen.dart';

class EmployerSendNewMessageScreen extends StatefulWidget {
  static const routeName = "New_Message";

  const EmployerSendNewMessageScreen({Key? key}) : super(key: key);

  @override
  _EmployerSendNewMessageScreenState createState() =>
      _EmployerSendNewMessageScreenState();
}

class _EmployerSendNewMessageScreenState
    extends State<EmployerSendNewMessageScreen> {
  //
  // Function that takes the Navigator back to the Message Page
  void goBackToMessagePage(BuildContext ctx) async {
    // Extract user info from the Navigator
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    String userFirstName = routeArgs['userFirstName'] as String;
    String userLastName = routeArgs['userLastName'] as String;
    String userEmail = routeArgs['userEmail'] as String;

    String userId = routeArgs['userId'] as String;

    int userNewMessages = routeArgs['userNewMessages'] as int;

    String userUrlProfilePicture = routeArgs['userUrlProfilePicture'] as String;

    await Navigator.of(ctx).popAndPushNamed(
      EmployerMessagingScreen.nameRoute,
      arguments: {
        'userFirstName': userFirstName,
        'userLastName': userLastName,
        'userId': userId,
        'userEmail': userEmail,
        'userNewMessages': userNewMessages,
        'userUrlProfilePicture': userUrlProfilePicture,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calculate Device's Dimension
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final screenDeviceHeight = MediaQuery.of(context).size.height;
    final screenDeviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppbar(context, goBackToMessagePage),
      body: Column(
        children: <Widget>[
          Container(
            height: 0.07 * screenDeviceHeight,
            padding: EdgeInsets.only(
              top: 10,
              left: screenDeviceWidth * 0.1,
              right: screenDeviceWidth * 0.1,
            ),
            child: TextFormField(
              textAlignVertical: TextAlignVertical.bottom,
              decoration: InputDecoration(
                fillColor: Colors.grey.shade200,
                icon: Text(
                  "To:",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                filled: true,
                hintText: "Type a name from your connections",
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

AppBar getAppbar(
  BuildContext ctx,
  Function goBackToMessagePage,
) {
  return AppBar(
    backgroundColor: Colors.blue.shade900,
    elevation: 4.0,
    centerTitle: true,
    title: Text(
      "New Message",
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
    leading: IconButton(
      onPressed: () {
        // TODO: ...
        goBackToMessagePage(ctx);
      },
      icon: Icon(
        Icons.close,
        color: Colors.white,
      ),
    ),
  );
}
