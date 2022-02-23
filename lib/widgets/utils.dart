import 'dart:io';
import 'package:autism_bridge/constants.dart';
import 'package:autism_bridge/widgets/resume_builder_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Utils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String? text, Icon leadingIconWidget) {
    if (text == null) return;

    final snackBar = SnackBar(
      content: Row(
        children: [
          SizedBox(
            width: 1.5.h,
          ),
          leadingIconWidget,
          SizedBox(
            width: 1.5.h,
          ),
          SizedBox(
            width: 65.w,
            child: Text(
              text,
              style: TextStyle(
                color: const Color(0xFF1F1F39),
                fontSize: 9.5.sp,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white, //const Color(0xFFF0F0F2),
      behavior: SnackBarBehavior.floating,
      //width: double.infinity,
      shape: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        borderSide: BorderSide(
          color: Color(0xFFF0F0F2),
          //width: 5.0,
        ),
      ),
    );

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static showProgressIndicator(BuildContext context) {
    if (Platform.isIOS) {
      showDialog(
        barrierColor: Colors.transparent,
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CupertinoActivityIndicator(),
        ),
      );
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(
              kAutismBridgeBlue,
            ),
          ),
        ),
      );
    }
  }

  static Future<bool> showCupertinoDialog(BuildContext context) async {
    bool wantDelete = false;
    await showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Do you want to delete this record?'),
        actions: <Widget>[
          CupertinoDialogAction(
            child: const Text('Yes'),
            onPressed: () {
              wantDelete = true;
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            child: const Text('No'),
            onPressed: () {
              wantDelete = false;
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );

    return wantDelete;
  }

  static Future<bool> showMyDialog(BuildContext context) async {
    bool wantDelete = false;
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
            insetPadding: EdgeInsets.symmetric(
              horizontal: 8.h,
              vertical: 6.h,
            ),
            backgroundColor: kBackgroundRiceWhite,
            title: Text(
              'Do you want to delete this record ?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                color: kTitleBlack,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            // titleTextStyle: const TextStyle(
            //     fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
            //actionsOverflowButtonSpacing: 20,
            actions: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 1.5.h, vertical: 1.h),
                      child: SizedBox(
                        height: 5.7.h,
                        child: ResumeBuilderButton(
                            disableBorder: true,
                            onPressed: () {
                              wantDelete = true;
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Yes',
                              style: TextStyle(
                                color: kWelcomeSubtitleGrey,
                                fontFamily: 'Poppins',
                                fontSize: 12.sp,
                              ),
                            ),
                            isHollow: true),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 1.5.h,
                        vertical: 1.h,
                      ),
                      child: SizedBox(
                        height: 5.7.h,
                        child: ResumeBuilderButton(
                            onPressed: () {
                              wantDelete = false;
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'No',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontSize: 12.sp,
                              ),
                            ),
                            isHollow: false),
                      ),
                    ),
                  ),
                ],
              ),
            ], //content: Text("Saved successfully"),
          );
        });
    return wantDelete;
  }
}
