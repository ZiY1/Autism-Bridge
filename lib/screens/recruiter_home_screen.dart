import 'package:autism_bridge/constants.dart';
import 'package:autism_bridge/models/recruiter_company_info.dart';
import 'package:autism_bridge/models/recruiter_profile.dart';
import 'package:autism_bridge/models/recruiter_user_credentials.dart';
import 'package:autism_bridge/screens/recruiter_me_screen.dart';
import 'package:autism_bridge/screens/welcome_screen.dart';
import 'package:autism_bridge/widgets/my_bottom_nav_bar.dart';
import 'package:autism_bridge/widgets/my_bottom_nav_bar_icon.dart';
import 'package:autism_bridge/widgets/my_bottom_nav_bar_indicator.dart';
import 'package:autism_bridge/widgets/my_bottom_nav_bar_label.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RecruiterHomeScreen extends StatefulWidget {
  static const id = 'recruiter_home_screen';

  final RecruiterUserCredentials recruiterUserCredentials;

  final RecruiterProfile recruiterProfile;

  final RecruiterCompanyInfo recruiterCompanyInfo;

  const RecruiterHomeScreen({
    Key? key,
    required this.recruiterUserCredentials,
    required this.recruiterProfile,
    required this.recruiterCompanyInfo,
  }) : super(key: key);

  @override
  State<RecruiterHomeScreen> createState() => _RecruiterHomeScreenState();
}

class _RecruiterHomeScreenState extends State<RecruiterHomeScreen> {
  final _auth = FirebaseAuth.instance;

  int bottomNavBarCurrentIndex = 0;

  List<Widget> screens = [];

  List<PreferredSizeWidget?> appBars = [];

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

    screens.add(
      const Center(
        child: Text(
          'Candidates Screen',
        ),
      ),
    );
    screens.add(
      const Center(
        child: Text('Message Screen'),
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
      RecruiterMeScreen(
        recruiterUserCredentials: widget.recruiterUserCredentials,
        recruiterProfile: widget.recruiterProfile,
      ),
    );

    appBars.add(AppBar(
      elevation: 0,
      flexibleSpace: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TabBar(
            isScrollable: true, // Required
            unselectedLabelColor: Colors.white.withOpacity(0.8),
            unselectedLabelStyle: TextStyle(
              fontSize: 11.7.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              letterSpacing: 0.3,
            ),
            labelPadding:
                EdgeInsets.symmetric(horizontal: 1.5.h), // Space between tabs
            indicatorColor: Colors.transparent,
            labelColor: Colors.white,
            labelStyle: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              letterSpacing: 0.3,
            ),
            tabs: const [
              Tab(text: 'Software Engineer'),
              Tab(text: 'UI Designer'),
              Tab(text: 'Product Manager'),
            ],
          ),
        ],
      ),
      backgroundColor: kAutismBridgeBlue,
    ));
    appBars.add(AppBar());
    appBars.add(AppBar());
    appBars.add(AppBar());
    appBars.add(null);
  }

  @override
  Widget build(BuildContext context) {
    const double navBarIconSize = 3.425;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: kBackgroundRiceWhite,
        appBar: appBars[bottomNavBarCurrentIndex],
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
              MyBottomNavBarIndicator(
                isSelected: bottomNavBarCurrentIndex == 0 ? true : false,
              ),
              // SizedBox(
              //   width: 10.92.w,
              // ),
              MyBottomNavBarIndicator(
                isSelected: bottomNavBarCurrentIndex == 1 ? true : false,
              ),
              // SizedBox(
              //   width: 30.07.w,
              // ),
              const MyBottomNavBarIndicator(
                isSelected: false,
              ),
              MyBottomNavBarIndicator(
                isSelected: bottomNavBarCurrentIndex == 3 ? true : false,
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
                iconPath: 'images/icon_cv.png',
                scale: 1.625,
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
              MyBottomNavBarLabel(
                isSelected: bottomNavBarCurrentIndex == 0 ? true : false,
                onPressed: jobBtnOnPressed,
                labelName: '   Jobs   ',
              ),
              // SizedBox(
              //   width: 9.w,
              // ),
              MyBottomNavBarLabel(
                isSelected: bottomNavBarCurrentIndex == 1 ? true : false,
                onPressed: messageBtnOnPressed,
                labelName: 'Message',
              ),
              // SizedBox(
              //   width: 7.35.w,
              // ),
              MyBottomNavBarLabel(
                isSelected: bottomNavBarCurrentIndex == 2 ? true : false,
                onPressed: searchBtnOnPressed,
                labelName: 'Search     ',
              ),
              // SizedBox(
              //   width: 8.9.w,
              // ),
              MyBottomNavBarLabel(
                isSelected: bottomNavBarCurrentIndex == 3 ? true : false,
                onPressed: homeBtnOnPressed,
                labelName: 'VR        ',
              ),
              // SizedBox(
              //   width: 12.2.w,
              // ),
              MyBottomNavBarLabel(
                isSelected: bottomNavBarCurrentIndex == 4 ? true : false,
                onPressed: meBtnOnPressed,
                labelName: '  Me   ',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
