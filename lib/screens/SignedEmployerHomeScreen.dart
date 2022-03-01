// Imported Screen
import 'package:autism_bridge/screens/SignInEmployerScreen.dart';
import 'package:autism_bridge/screens/SignedEmployerHomeMainContent.dart';
import 'package:autism_bridge/screens/SignedEmployerMessagingScreen.dart';
import 'package:autism_bridge/screens/SignedEmployerProfileScreen.dart';
import 'package:autism_bridge/screens/SignedEmployerSettingsScreen.dart';
// Imported libraries
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
// Imported Customized Widgets
import 'package:autism_bridge/widgets/NotificationIcon.dart';
// Imported models
import 'package:autism_bridge/models/Employer.dart';

// Global variable
final FirebaseFirestore autismBridgeFireBaseFireStore =
    FirebaseFirestore.instance;
final FirebaseAuth authentication = FirebaseAuth.instance;

class SignedEmployerHomeScreen extends StatefulWidget {
  static String routeName = "Recuiter_MainPage";

  final Employer employer;

  const SignedEmployerHomeScreen({required this.employer}) : super();
  @override
  _SignedEmployerHomeScreenState createState() =>
      _SignedEmployerHomeScreenState();
}

class _SignedEmployerHomeScreenState extends State<SignedEmployerHomeScreen> {
  //
  // Gather the Employer info

  Employer? signedEmployer;

  @override
  void initState() {
    super.initState();
    // Get the Current Employer info
    signedEmployer = widget.employer;
    //getCurrentUser();
  }

  /*
  Future<void> getCurrentUser() async {
    try {
      final currentUser = authentication.currentUser;
      if (currentUser != null) {
        userEmail = currentUser.email!;
        userId = currentUser.uid;
        await getUsername();
      }
    } catch (e) {
      print(e);
    }
  }*/

  /*
  Future<void> getUsername() async {
    await autismBridgeFireBaseFireStore
        .collection('EmployerUsers')
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        // Map contain user data
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        // Get the data and create an Employer Object
        userFirstName = data['userFirstName'];
        userLastName = data['userLastName'];
        userPassword = data['userPassword'];
        userUrlProfilePicture = data['urlProfileImage'];
        userNewMessages = data['userNewMessages'];
        signedEmployer = Employer(
          userId: userId,
          userUrlProfilePicture: userUrlProfilePicture,
          userFirstName: userFirstName,
          userLastName: userLastName,
          userEmail: userEmail,
          userPassword: userPassword,
          userNewMessages: userNewMessages,
        );

        //print(userFirstName);
      } else {
        print('Document does not exist on the database');
      }
    });
  }*/

  //
  // State Tab index
  int currentTabIndex = 0;

  // Function that controls the State tab index
  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  // ScaffoldKey to open drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Function that tells the Navigator to go to MessagingPage
  void goToMessagingPage(BuildContext ctx, Employer signedEmployer) async {
    await Navigator.of(ctx).pushNamed(
      EmployerMessagingScreen.nameRoute,
      arguments: {
        'signedEmployer': signedEmployer,
      },
    );
  }

  void goToMyProfilePage(BuildContext ctx, Employer signedEmployer) async {
    // Go to Employer user Profile Page
    await Navigator.of(ctx)
        .popAndPushNamed(EmployerProfilePage.routeName, arguments: {
      'signedEmployer': signedEmployer,
    });
  }

  void goToSettingsPage(BuildContext ctx, Employer signedEmployer) async {
    // Go to Employer user Profile Page
    await Navigator.of(ctx).popAndPushNamed(
      EmployerSettingsScreen.routeName,
      arguments: {
        'signedEmployer': signedEmployer,
      },
    );
  }

  // boolean flag that will show when to display a progress indicator
  bool _isLoading = false;

  // Function that logs out the user
  void logOutUser(BuildContext ctx) async {
    setState(() {
      _isLoading = true;
    });
    // Sign user out
    await FirebaseAuth.instance.signOut();
    // Send the user back to Sign in Page
    await Navigator.of(ctx).popAndPushNamed(
      SignInEmployerPage.nameRoute,
    );
  }

  @override
  Widget build(BuildContext context) {
    //
    // Calculate Device's Dimension
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final screenDeviceHeight = MediaQuery.of(context).size.height;
    final screenDeviceWidth = MediaQuery.of(context).size.width;

    // AppBar State List
    List<AppBar> appBarStates = [
      returnAppBar(
          0, context, goToMessagingPage, signedEmployer!, _scaffoldKey),
      returnAppBar(
          1, context, goToMessagingPage, signedEmployer!, _scaffoldKey),
      returnAppBar(
          2, context, goToMessagingPage, signedEmployer!, _scaffoldKey),
    ];

    // Tabs State List
    List<Widget> tabs = [
      EmployerHomeTabSearch(),
      Center(
        child: Text("VR Section"),
      ),
      Center(
        child: Text("Post Jobs"),
      ),
    ];

    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SafeArea(
            child: Scaffold(
                          backgroundColor: Colors.grey.shade200,
                          appBar: appBarStates[currentTabIndex],
                          key: _scaffoldKey,
                          drawer: buildMainPageDrawer(
                              context,
                              logOutUser,
                              goToMyProfilePage,
                              goToSettingsPage,
                              signedEmployer!),
                          drawerEnableOpenDragGesture: true,
                          body: SafeArea(
                            child: _isLoading
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : SingleChildScrollView(
                                    child: tabs[currentTabIndex]),
                          ),
                          bottomNavigationBar: Container(
                            color: Colors.white,
                            height: 60,
                            child: BottomNavigationBar(
                              onTap: onTapped,
                              currentIndex: currentTabIndex,
                              backgroundColor: Colors.white,
                              unselectedLabelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              selectedItemColor: Colors.blue.shade700,
                              selectedIconTheme: IconThemeData(
                                color: Colors.blue.shade700,
                              ),
                              selectedLabelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                              ),
                              items: [
                                BottomNavigationBarItem(
                                  icon: Stack(children: <Widget>[
                                    Icon(Icons.search),
                                  ]),
                                  label: 'Search',
                                ),
                                BottomNavigationBarItem(
                                    icon: Stack(
                                      children: <Widget>[
                                        Icon(Icons.video_label_rounded)
                                      ],
                                    ),
                                    label: "VR"),
                                BottomNavigationBarItem(
                                  icon: Stack(children: <Widget>[
                                    Icon(Icons.post_add),
                                  ]),
                                  label: 'Post Job',
                                ),
                              ],
                            ),
                          ),
                        )
                ,
          ),
        );
  }
}

AppBar returnAppBar(
  int idx,
  BuildContext ctx,
  Function goToMessaging,
  Employer signedEmployer,
  GlobalKey<ScaffoldState> Scaffoldkey,
) {
  // Calculate Device's Dimension
  final textScaleFactor = MediaQuery.of(ctx).textScaleFactor;
  final screenDeviceHeight = MediaQuery.of(ctx).size.height;
  final screenDeviceWidth = MediaQuery.of(ctx).size.width;

  // Get the userEmployerInfo
  String userFirstName = signedEmployer.firstName;
  String userLastName = signedEmployer.lastName;
  String userEmail = signedEmployer.email;
  String userId = signedEmployer.id;
  int userNewMessages = signedEmployer.newMessages;
  String userUrlProfilePicture = signedEmployer.urlProfilePicture;

  AppBar myAppBar = AppBar();

  if (idx == 0) {
    myAppBar = AppBar(
      toolbarHeight: screenDeviceHeight * 0.17,
      backgroundColor: Colors.blue.shade900,
      actions: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: 50,
            right: 20,
          ),
          child: userNewMessages == 0
              ? IconButton(
                  onPressed: () {
                    // Go to Message Page
                    goToMessaging(ctx, signedEmployer);
                  },
                  icon: Icon(
                    Icons.message_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                )
              : NotificationIcon(
                  onTap: () {
                    // Go to Message Page
                    goToMessaging(ctx, signedEmployer);
                  },
                  text: "",
                  iconData: Icons.message_rounded,
                  topPosition: 15,
                  colorChoosen: Colors.white,
                  sizeChoosen: 30,
                  notificationCount: userNewMessages,
                ),
        )
      ],
      automaticallyImplyLeading: false,
      title: Container(
        color: Colors.blue.shade900,
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Container(
                  child: InkWell(
                    onTap: () {
                      Scaffoldkey.currentState?.openDrawer();
                    },
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(userUrlProfilePicture),
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(
                      left: 15,
                    ),
                    child: Text(
                      "Welcome back,\n$userFirstName!",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18 * textScaleFactor,
                      ),
                    )),
              ],
            ),
            Container(
              color: Colors.blue.shade900,
              padding: EdgeInsets.only(
                top: screenDeviceHeight * 0.015,
                left: screenDeviceWidth * 0.01,
              ),
              height: 40,
              child: TextFormField(
                textAlignVertical: TextAlignVertical.bottom,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Icon(Icons.search),
                  hintText: "Start a search here...",
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  } else if (idx == 1) {
    myAppBar = AppBar(
      toolbarHeight: screenDeviceHeight * 0.15,
      backgroundColor: Colors.blue.shade200,
      actions: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: 60,
            right: 20,
          ),
          child: userNewMessages == 0
              ? IconButton(
                  onPressed: () {
                    // Go to Message Page
                    goToMessaging(ctx);
                  },
                  icon: Icon(
                    Icons.message_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                )
              : NotificationIcon(
                  onTap: () {
                    // Go to Message Page
                    goToMessaging(ctx);
                  },
                  text: "",
                  iconData: Icons.message_rounded,
                  topPosition: 22,
                  colorChoosen: Colors.white,
                  sizeChoosen: 30,
                  notificationCount: userNewMessages,
                ),
        )
      ],
      automaticallyImplyLeading: false,
      title: Container(
        color: Colors.blue.shade200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: InkWell(
                onTap: () {
                  Scaffoldkey.currentState?.openDrawer();
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage(userUrlProfilePicture),
                ),
              ),
            ),
            Center(
              child: Text(
                "$userFirstName $userLastName",
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              color: Colors.blue.shade200,
              padding: EdgeInsets.only(
                top: screenDeviceHeight * 0.005,
                left: screenDeviceWidth * 0.01,
              ),
              height: 30,
              child: TextFormField(
                textAlignVertical: TextAlignVertical.bottom,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Icon(Icons.search),
                  hintText: "Start a search here...",
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  } else if (idx == 2) {
    //
    myAppBar = AppBar(
      backgroundColor: Colors.blue.shade200,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.close,
          color: Colors.white,
        ),
        onPressed: () {
          // TODO: Double check if it works without bugs and retake the arguments
          Navigator.of(ctx).popAndPushNamed(
            SignedEmployerHomeScreen.routeName,
            arguments: {
              'userFirstName': userFirstName,
              'userLastName': userLastName,
              'userId': userId,
              'userEmail': userEmail,
              'userNewMessages': userNewMessages,
              'userUrlProfilePicture': userUrlProfilePicture,
            },
          );
        },
      ),
      title: Text(
        "Start Post",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  return myAppBar;
}

Drawer buildMainPageDrawer(
  BuildContext ctx,
  Function logOutUser,
  Function goToMyProfilePage,
  Function goToSettingsPage,
  Employer signedEmployer,
) {
  //
  // Get the arguments from the Navigator

  String userFirstName = signedEmployer.firstName;
  String userLastName = signedEmployer.lastName;
  String userEmail = signedEmployer.email;
  String userId = signedEmployer.id;
  String userUrlProfilePicture = signedEmployer.urlProfilePicture;

  Drawer mainPageDrawer = Drawer(
    backgroundColor: Colors.grey.shade200,
    elevation: 3.0,
    child: ListView(
      children: <Widget>[
        Container(
          color: Colors.blue.shade100,
          child: ListTile(
            minLeadingWidth: 0,
            leading: InkWell(
              onTap: () {
                // Go to my Profile Page
                goToMyProfilePage(ctx);
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(userUrlProfilePicture),
              ),
            ),
            title: Text(
              "$userFirstName $userLastName",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            subtitle: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        right: 10,
                      ),
                      child: InkWell(
                        onTap: () {
                          // Go to my Profile Page
                          goToMyProfilePage(ctx);
                        },
                        child: Text(
                          "View Profile",
                          style: TextStyle(
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20,
                      ),
                      child: InkWell(
                        onTap: () {
                          // TODO: Go to Settings Page
                          goToSettingsPage(ctx);
                        },
                        child: Text(
                          "Settings",
                          style: TextStyle(
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        // TODO: ...
                        Navigator.pop(ctx);
                        logOutUser(ctx);
                      },
                      icon: Icon(
                        Icons.power_settings_new,
                      ),
                    ),
                  ],
                )
              ],
            ),
            isThreeLine: true,
            trailing: InkWell(
              onTap: () {
                Navigator.pop(ctx);
              },
              child: Icon(
                Icons.close_sharp,
              ),
            ),
          ),
        ),
      ],
    ),
  );

  return mainPageDrawer;
}

/*
BottomNavigationBarItem returnBottomNavigatorPeople(int noInvitation) {
  if (noInvitation == 0) {
    return BottomNavigationBarItem(
      icon: Stack(children: <Widget>[
        Icon(Icons.people),
      ]),
      label: 'My Network',
    );
  } else if (noInvitation <= 99) {
    return BottomNavigationBarItem(
      icon: Container(
        width: 46,
        child: Stack(
          children: <Widget>[
            Icon(Icons.people),
            Positioned(
              left: 23,
              bottom: 7,
              child: Container(
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Colors.red,
                  //borderRadius: BorderRadius.circular(8),
                  shape: BoxShape.circle,
                ),
                constraints: BoxConstraints(
                  minWidth: 25,
                  minHeight: 20,
                ),
                child: Center(
                  child: Text(
                    '$noInvitation',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      label: 'My Network',
    );
  } else {
    return BottomNavigationBarItem(
      icon: Container(
        width: 56,
        child: Stack(
          children: <Widget>[
            Icon(Icons.people),
            Positioned(
              left: 23,
              bottom: 3,
              child: Container(
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Colors.red,
                  //borderRadius: BorderRadius.circular(8),
                  shape: BoxShape.circle,
                ),
                constraints: BoxConstraints(
                  minWidth: 25,
                  minHeight: 24,
                ),
                child: Center(
                  child: Text(
                    '+99',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      label: 'My Network',
    );
  }
}
*/
