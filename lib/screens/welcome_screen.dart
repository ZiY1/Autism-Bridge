import 'dart:async';

import 'package:autism_bridge/models/welcome_item.dart';
import 'package:autism_bridge/screens/asd_login_screen.dart';

import 'package:autism_bridge/screens/SignInEmployerScreen.dart';

import 'package:flutter/material.dart';
import 'package:autism_bridge/widgets/slide_dot.dart';
import 'package:autism_bridge/widgets/slide_item.dart';
import 'package:autism_bridge/widgets/welcome_button.dart';
import 'package:sizer/sizer.dart';

class WelcomeScreen extends StatefulWidget {
  static const id = 'welcome_screen';

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  // Function that takes the Navigator to Employer Sign in Page
  void goToSignInEmployerPage(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      SignInEmployerPage.nameRoute,
      arguments: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.7.h, vertical: 4.4.h),
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    PageView.builder(
                      scrollDirection: Axis.horizontal,
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      itemCount: slideList.length,
                      itemBuilder: (ctx, i) => SlideItem(index: i),
                    ),
                    Stack(
                      alignment: AlignmentDirectional.topStart,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 5.5.h),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              for (int i = 0; i < slideList.length; i++)
                                if (i == _currentPage)
                                  const SlideDot(isActive: true)
                                else
                                  const SlideDot(isActive: false)
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 1.5.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    WelcomeButton(
                      btnName: 'Hire employees',
                      onPressed: () {
                        // TODO: Billy: Button Function
                        // Send the navigator to the SignInPage of Employer
                        goToSignInEmployerPage(context);
                      },
                      isHollow: true,
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    WelcomeButton(
                      btnName: 'Find jobs',
                      onPressed: () {
                        // TODO: Button Function
                        Navigator.pushNamed(context, AsdLoginScreen.id);
                      },
                      isHollow: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
