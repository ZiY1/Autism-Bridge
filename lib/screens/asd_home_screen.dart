import 'package:autism_bridge/constants.dart';
import 'package:autism_bridge/models/asd_user_credentials.dart';
import 'package:autism_bridge/models/job_display.dart';
import 'package:autism_bridge/models/job_preference_data.dart';
import 'package:autism_bridge/models/resume_data.dart';
import 'package:autism_bridge/screens/asd_job_screen.dart';
import 'package:autism_bridge/screens/asd_me_screen.dart';
import 'package:autism_bridge/widgets/my_bottom_nav_bar.dart';
import 'package:autism_bridge/widgets/my_bottom_nav_bar_icon.dart';
import 'package:autism_bridge/widgets/my_bottom_nav_bar_indicator.dart';
import 'package:autism_bridge/widgets/my_bottom_nav_bar_label.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AsdHomeScreen extends StatefulWidget {
  static const id = 'asd_home_screen';

  final AsdUserCredentials asdUserCredentials;

  final Resume userResume;

  final List<JobPreference?> userJobPreferenceList;

  const AsdHomeScreen({
    Key? key,
    required this.asdUserCredentials,
    required this.userResume,
    required this.userJobPreferenceList,
  }) : super(key: key);

  @override
  State<AsdHomeScreen> createState() => _AsdHomeScreenState();
}

class _AsdHomeScreenState extends State<AsdHomeScreen> {
  Resume? userResume;

  List<JobPreference?>? userJobPreferenceList;

  int bottomNavBarCurrentIndex = 0;

  List<Widget> screens = [];

  List<Tab> tabNameList = [];

  int currentTabIndex = 0;

  List<JobDisplay> jobDisplayEmptyList = [];

  void resumeOnChanged(Resume resumeTemp) {
    userResume = resumeTemp;

    screens[1] = Center(
      child: Text('Test Screen ${userResume!.userPersonalDetails!.firstName}'),
    );
  }

  void jobPreferenceListOnChanged(List<JobPreference?> jobPreferenceListTemp) {
    tabNameList.clear();
    if (userJobPreferenceList!.length > jobPreferenceListTemp.length &&
        currentTabIndex == userJobPreferenceList!.length - 1) {
      currentTabIndex = jobPreferenceListTemp.length - 1;
    }
    setState(() {
      userJobPreferenceList = jobPreferenceListTemp;
      tabNameListRebuild();
      screens[0] = AsdJobScreen(
        currentTabIndex: currentTabIndex,
        userJobPreferenceList: userJobPreferenceList!,
        tabTextList: tabNameList,
        tabListenerCallback: tabListenerOnChanged,
      );
    });
  }

  Future<void> tabListenerOnChanged(int tabIndex) async {
    currentTabIndex = tabIndex;
    // Need to call setState
    //print(userJobPreferenceList![tabIndex]!.getJobTitle);
    setState(() {
      screens[0] = AsdJobScreen(
        currentTabIndex: currentTabIndex,
        userJobPreferenceList: userJobPreferenceList!,
        tabTextList: tabNameList,
        tabListenerCallback: tabListenerOnChanged,
      );
    });
    //_asdJobScreenState.
  }

  void tabNameListRebuild() {
    for (int i = 0; i < userJobPreferenceList!.length; i++) {
      tabNameList.add(
        Tab(
          child: Text(userJobPreferenceList![i]!.getJobTitle),
        ),
      );
    }
  }

  void jobBtnOnPressed() {
    setState(() {
      bottomNavBarCurrentIndex = 0;
    });
  }

  void messageBtnOnPressed() {
    setState(() {
      bottomNavBarCurrentIndex = 1;
    });
  }

  void searchBtnOnPressed() {
    setState(() {
      bottomNavBarCurrentIndex = 2;
    });
  }

  void homeBtnOnPressed() {
    setState(() {
      bottomNavBarCurrentIndex = 3;
    });
  }

  void meBtnOnPressed() {
    setState(() {
      bottomNavBarCurrentIndex = 4;
    });
  }

  @override
  void initState() {
    super.initState();

    userResume = widget.userResume;

    userJobPreferenceList = widget.userJobPreferenceList;

    tabNameListRebuild();

    screens.add(
      // TODO: change to TabBarView
      // TabBarView(
      //   controller: _controller!,
      //   children: [
      //     AsdJobScreen(
      //       userJobPreference: userJobPreferenceList![0]!,
      //     ),
      //     AsdJobScreen(
      //       userJobPreference: userJobPreferenceList![0]!,
      //     ),
      //   ],
      // ),
      AsdJobScreen(
        currentTabIndex: currentTabIndex,
        userJobPreferenceList: userJobPreferenceList!,
        tabTextList: tabNameList,
        tabListenerCallback: tabListenerOnChanged,
      ),
    );
    screens.add(
      Center(
        child:
            Text('Test Screen ${userResume!.userPersonalDetails!.firstName}'),
      ),
    );
    screens.add(
      const Center(
        child: Text('Search Screen'),
      ),
    );
    screens.add(
      const Center(
        child: Text('Calendar Screen'),
      ),
    );
    screens.add(
      AsdMeScreen(
        asdUserCredentials: widget.asdUserCredentials,
        userResume: userResume!,
        onResumeValueChanged: resumeOnChanged,
        onJobPreferenceListValueChanged: jobPreferenceListOnChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double navBarIconSize = 3.425;
    return DefaultTabController(
      length: userJobPreferenceList!.length,
      child: Scaffold(
        body: screens[bottomNavBarCurrentIndex],
        bottomNavigationBar: MyBottomNavBar(
          middleSearch: GestureDetector(
            onTap: searchBtnOnPressed,
            child: Container(
              width: 6.4.h,
              height: 6.4.h,
              child: Padding(
                padding: EdgeInsets.only(bottom: 0.15.h, right: 0.1.h),
                child: Image.asset(
                  'images/icon_search.png',
                  scale: 3.3,
                  color: bottomNavBarCurrentIndex == 2
                      ? kAutismBridgeBlue
                      : const Color(0xFFB8B8D2),
                ),
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF3D5CFF).withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          firstRow: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 0.05.h),
                child: MyBottomNavBarIndicator(
                  isSelected: bottomNavBarCurrentIndex == 0 ? true : false,
                ),
              ),
              // SizedBox(
              //   width: 10.92.w,
              // ),
              Padding(
                padding: EdgeInsets.only(right: 0.6.h),
                child: MyBottomNavBarIndicator(
                  isSelected: bottomNavBarCurrentIndex == 1 ? true : false,
                ),
              ),
              // SizedBox(
              //   width: 30.07.w,
              // ),
              const MyBottomNavBarIndicator(
                isSelected: false,
              ),
              Padding(
                padding: EdgeInsets.only(right: 0.6.h),
                child: MyBottomNavBarIndicator(
                  isSelected: bottomNavBarCurrentIndex == 3 ? true : false,
                ),
              ),
              // SizedBox(
              //   width: 11.1.w,
              // ),
              MyBottomNavBarIndicator(
                isSelected: bottomNavBarCurrentIndex == 4 ? true : false,
              ),
            ],
          ),
          secondRow: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyBottomNavBarIcon(
                isSelected: bottomNavBarCurrentIndex == 0 ? true : false,
                onPressed: jobBtnOnPressed,
                iconPath: 'images/icon_job.png',
                scale: 3.425,
              ),
              MyBottomNavBarIcon(
                isSelected: bottomNavBarCurrentIndex == 1 ? true : false,
                onPressed: messageBtnOnPressed,
                iconPath: 'images/icon_message.png',
                scale: 3.425,
              ),
              Image.asset(
                'images/icon_search.png',
                scale: navBarIconSize,
                color: Colors.transparent,
              ),
              MyBottomNavBarIcon(
                isSelected: bottomNavBarCurrentIndex == 3 ? true : false,
                onPressed: homeBtnOnPressed,
                iconPath: 'images/icon_vr.png',
                scale: 1.6,
              ),
              MyBottomNavBarIcon(
                isSelected: bottomNavBarCurrentIndex == 4 ? true : false,
                onPressed: meBtnOnPressed,
                iconPath: 'images/icon_me.png',
                scale: 3.425,
              ),
            ],
          ),
          thirdRow: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 3.h),
                child: MyBottomNavBarLabel(
                  isSelected: bottomNavBarCurrentIndex == 0 ? true : false,
                  onPressed: jobBtnOnPressed,
                  labelName: '   Jobs   ',
                ),
              ),
              // SizedBox(
              //   width: 9.w,
              // ),
              Padding(
                padding: EdgeInsets.only(left: 0.2.h),
                child: MyBottomNavBarLabel(
                  isSelected: bottomNavBarCurrentIndex == 1 ? true : false,
                  onPressed: messageBtnOnPressed,
                  labelName: 'Message ',
                ),
              ),
              // SizedBox(
              //   width: 7.35.w,
              // ),
              Padding(
                padding: EdgeInsets.only(right: 0.9.h),
                child: MyBottomNavBarLabel(
                  isSelected: bottomNavBarCurrentIndex == 2 ? true : false,
                  onPressed: searchBtnOnPressed,
                  labelName: ' Search ',
                ),
              ),
              // SizedBox(
              //   width: 8.9.w,
              // ),
              Padding(
                padding: EdgeInsets.only(right: 2.29.h),
                child: MyBottomNavBarLabel(
                  isSelected: bottomNavBarCurrentIndex == 3 ? true : false,
                  onPressed: homeBtnOnPressed,
                  labelName: '   VR   ',
                ),
              ),
              // SizedBox(
              //   width: 12.2.w,
              // ),
              Padding(
                padding: EdgeInsets.only(right: 3.5.h),
                child: MyBottomNavBarLabel(
                  isSelected: bottomNavBarCurrentIndex == 4 ? true : false,
                  onPressed: meBtnOnPressed,
                  labelName: '   Me   ',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class GetUserName extends StatelessWidget {
//   final String documentId;
//
//   const GetUserName(this.documentId);
//
//   @override
//   Widget build(BuildContext context) {
//     CollectionReference users =
//         FirebaseFirestore.instance.collection('asd_users');
//
//     return FutureBuilder<DocumentSnapshot>(
//       future: users.doc(documentId).get(),
//       builder:
//           (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//         if (snapshot.hasError) {
//           return const Text("Something went wrong");
//         }
//
//         if (snapshot.hasData && !snapshot.data!.exists) {
//           return const Text("Document does not exist");
//         }
//
//         if (snapshot.connectionState == ConnectionState.done) {
//           Map<String, dynamic> data =
//               snapshot.data!.data() as Map<String, dynamic>;
//           return Text("Full Name: ${data['name']}");
//         }
//
//         return const Text("loading");
//       },
//     );
//   }
// }

// PreferredSize(
// preferredSize: const Size.fromHeight(kToolbarHeight),
// child: Container(
// color: kAutismBridgeBlue,
// child: SafeArea(
// child: Column(
// children: [
// Expanded(child: Container()),
// TabBar(
// isScrollable: true, // Required
// unselectedLabelColor: Colors.white30, // Other tabs color
// labelPadding: EdgeInsets.symmetric(
// horizontal: 30), // Space between tabs
// indicator: UnderlineTabIndicator(
// borderSide: BorderSide(
// color: Colors.white, width: 2), // Indicator height
// insets: EdgeInsets.symmetric(
// horizontal: 48), // Indicator width
// ),
// tabs: [
// Tab(text: 'Total Investment'),
// Tab(text: 'Your Earnings'),
// Tab(text: 'Current Balance'),
// ],
// ),
// ],
// ),
// ),
// ),
// ),
