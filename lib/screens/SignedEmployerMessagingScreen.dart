import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:autism_bridge/screens/SignedEmployerHomeScreen.dart';
import 'package:autism_bridge/screens/SignedEmployerNewMessageScreen.dart';

import 'package:autism_bridge/widgets/MessagTile.dart';
import 'package:autism_bridge/models/Employer.dart';

class EmployerMessagingScreen extends StatefulWidget {
  static const nameRoute = "MyMessages";

  const EmployerMessagingScreen({Key? key}) : super(key: key);

  @override
  _EmployerMessagingScreenState createState() =>
      _EmployerMessagingScreenState();
}

class _EmployerMessagingScreenState extends State<EmployerMessagingScreen> {
  //
  // Function that takes the Navigator back
  void goBackToHomePage(BuildContext ctx) {
    // TODO: sent back the info of the logged user in arguments

    // Extract user info from the Navigator
    Navigator.of(ctx).popAndPushNamed(
      SignedEmployerHomeScreen.routeName,
    );
  }

  void goToNewMessagePage(BuildContext ctx) async {
    // Extract user info from the Navigator
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    Employer signedEmployer = routeArgs['signedEmployer'] as Employer;

    // TODO: Fix arguments that you sent
    await Navigator.of(ctx).popAndPushNamed(
      EmployerSendNewMessageScreen.routeName,
      arguments: {
        'signedEmployer': signedEmployer,
      },
    );
  }

  bool deleteState = false;
  int numberOfSelectedTile = 0;
  bool isButtonDissable = true;
  List<String> listOfDeleteId = [];

  void deleteMessagestate() {
    setState(() {
      deleteState = !deleteState;
      numberOfSelectedTile = 0;
      isButtonDissable = true;
      listOfDeleteId = [];
    });
  }

  void updateSelectedTiles(bool update) {
    setState(() {
      update ? numberOfSelectedTile += 1 : numberOfSelectedTile -= 1;

      if (numberOfSelectedTile > 0) {
        isButtonDissable = false;
      } else {
        isButtonDissable = true;
      }
    });
  }

  void deleteSelectedTile(bool eliminate, String id) {
    if (eliminate) {
      // TODO: eliminate From the dataBase
      //

      setState(() {
        listOfDeleteId.add(id);
      });
    } else {
      if (listOfDeleteId.contains(id)) {
        setState(() {
          listOfDeleteId.remove(id);
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool _loadingScreen = false;

  @override
  Widget build(BuildContext context) {
    // Calculate Device's Dimension
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final screenDeviceHeight = MediaQuery.of(context).size.height;
    final screenDeviceWidth = MediaQuery.of(context).size.width;

    // Assuming we got the User info

    AssetImage profilePictureUser =
        AssetImage("assets/images/blank-person.jpg");

    // Extract user info from the Navigator
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    Employer signedEmployer = routeArgs['signedEmployer'] as Employer;
    String userEmail = signedEmployer.email;

    Stream<QuerySnapshot> messageStream = FirebaseFirestore.instance
        .collection(
          'Messages',
        )
        .where("To", isEqualTo: userEmail)
        .snapshots();

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: getDynamicAppBar(
          context,
          goBackToHomePage,
          deleteMessagestate,
          goToNewMessagePage,
          deleteState,
          numberOfSelectedTile,
        ),
        drawerEnableOpenDragGesture: true,
        body: SafeArea(
          child: _loadingScreen
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : getDynamicBody(
                  messageStream,
                  userEmail,
                  context,
                  profilePictureUser,
                  deleteState,
                  updateSelectedTiles,
                  deleteSelectedTile,
                ),
        ),
        persistentFooterButtons: deleteState
            ? getDynamicFooterBar(
                isButtonDissable,
                listOfDeleteId,
                context,
              )
            : [],
      ),
    );
  }
}

Widget getDynamicBody(
  Stream<QuerySnapshot> messageStream,
  String userEmail,
  BuildContext context,
  AssetImage profilePictureUser,
  bool deleteState,
  Function updateNumberOfSelectedTile,
  Function deleteSelectedTile,
) {
  //
  final screenDeviceHeight = MediaQuery.of(context).size.height;
  var listSearch = [
    Container(
      height: 0.07 * screenDeviceHeight,
      padding: EdgeInsets.only(
        top: 10,
        left: 20,
        right: 20,
      ),
      child: TextFormField(
        textAlignVertical: TextAlignVertical.bottom,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          prefixIcon: Icon(Icons.search),
          hintText: "Search messages",
          alignLabelWithHint: true,
          border: OutlineInputBorder(),
        ),
      ),
    ),
  ];

  CollectionReference messageCollection =
      FirebaseFirestore.instance.collection('Messages');

  return deleteState
      ? FutureBuilder<QuerySnapshot>(
          future: messageCollection.where("To", isEqualTo: userEmail).get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<DocumentSnapshot> documents = snapshot.data!.docs;

              return ListView(
                children: documents
                    .map(
                      (doc) => CheckMessageBoxTile(
                          UpdateNoOfSelectedTiles: updateNumberOfSelectedTile,
                          deleteSelectedTile: deleteSelectedTile,
                          deleteId: doc.reference.id,
                          profilePictureUser: profilePictureUser,
                          firstName: doc['FromName'],
                          lastName: doc['FromLastName'],
                          lastMessage: doc['MessageContext'],
                          receivedMessageDate: doc['Date'],
                          numberOfNewMessage: 5),
                    )
                    .toList(),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        )
      : StreamBuilder(
          stream: messageStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(
              children: List.from(listSearch)
                ..addAll(
                  snapshot.data!.docs.map(
                    (DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;

                      return MessageTile(
                        profilePictureUser: profilePictureUser,
                        firstName: data['FromName'],
                        lastName: data['FromLastName'],
                        lastMessage: data['MessageContext'],
                        receivedMessageDate: data['Date'],
                        numberOfNewMessage: 5,
                      );
                    },
                  ).toList(),
                ),
            );
          },
        );
}

AppBar getDynamicAppBar(
  BuildContext ctx,
  Function goBackToHomePage,
  Function deleteMessagestate,
  Function goToNewMessagePage,
  bool inDeleteMode,
  int numberOfSelectedTile,
) {
  // Calculate Device's Dimension
  final textScaleFactor = MediaQuery.of(ctx).textScaleFactor;
  final screenDeviceHeight = MediaQuery.of(ctx).size.height;
  final screenDeviceWidth = MediaQuery.of(ctx).size.width;

  // Function that returns the App Bar Message section
  AppBar getAppBarMessage() {
    return AppBar(
      toolbarHeight: 0.1 * screenDeviceHeight,
      leading: IconButton(
        onPressed: () {
          // Go back to previous page(Home Feed)
          goBackToHomePage(ctx);
        },
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.blue.shade900,
      elevation: 4.0,
      centerTitle: true,
      title: Text(
        "Messaging",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () {
            // TODO: ...
            deleteMessagestate();
          },
          icon: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () {
            // TODO: ...
            goToNewMessagePage(ctx);
          },
          icon: Icon(
            Icons.note_add_sharp,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  AppBar getAppBarDeleteMessage() {
    return AppBar(
      toolbarHeight: 0.1 * screenDeviceHeight,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.blue.shade900,
      elevation: 4.0,
      centerTitle: true,
      title: Text(
        (numberOfSelectedTile == 0)
            ? "Select"
            : "$numberOfSelectedTile Selected",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              // TODO: ...
              deleteMessagestate();
            },
            child: Text(
              "Cancel",
              style: TextStyle(
                color: Colors.grey.shade400,
              ),
            ))
      ],
    );
  }

  return inDeleteMode ? getAppBarDeleteMessage() : getAppBarMessage();
}

List<Widget> getDynamicFooterBar(
  bool isButtonDissable,
  List<String> listOfDeleteId,
  BuildContext ctx,
) {
  List<Widget> footBarButton = <Widget>[
    TextButton(
      onPressed: isButtonDissable
          ? null
          : () {
              // TODO: ...

              // Get a FirebaseStore connection of Message Document
              CollectionReference messagesCollection =
                  FirebaseFirestore.instance.collection('Messages');

              // Eliminate all the selected message Tile
              for (var i = 0; i < listOfDeleteId.length; i++) {
                String tempoId = listOfDeleteId[i];
                messagesCollection.doc(tempoId).delete();
              }

              // Reload the Page
              final routeArgs = ModalRoute.of(ctx)?.settings.arguments
                  as Map<String, dynamic>;

              String userFirstName = routeArgs['userFirstName'] as String;
              String userLastName = routeArgs['userLastName'] as String;
              String userEmail = routeArgs['userEmail'] as String;
              int userNewMessages = routeArgs['userNewMessages'] as int;

              Navigator.of(ctx).popAndPushNamed(
                EmployerMessagingScreen.nameRoute,
                arguments: {
                  'userFirstName': userFirstName,
                  'userLastName': userLastName,
                  'userEmail': userEmail,
                  'userNewMessages': userNewMessages,
                },
              );

              //
            },
      child: Text(
        "Delete",
        style: TextStyle(
          color: isButtonDissable ? Colors.grey.shade600 : Colors.blue.shade900,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    TextButton(
      onPressed: isButtonDissable
          ? null
          : () {
              // TODO: ...
            },
      child: Text(
        "Mark Unread",
        style: TextStyle(
          color: isButtonDissable ? Colors.grey.shade600 : Colors.blue.shade900,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    TextButton(
      onPressed: isButtonDissable
          ? null
          : () {
              // TODO: ...
            },
      child: Text(
        "Archive",
        style: TextStyle(
          color: isButtonDissable ? Colors.grey.shade600 : Colors.blue.shade900,
          fontWeight: FontWeight.bold,
        ),
      ),
    )
  ];

  return footBarButton;
}
