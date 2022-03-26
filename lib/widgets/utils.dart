import 'dart:convert';
import 'package:autism_bridge/color_constants.dart';
import 'package:autism_bridge/widgets/resume_builder_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:autism_bridge/modified_flutter_packages/picker_from_pack.dart';

import '../num_constants.dart';

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
                                color: kPickerCancelGrey,
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

  static void showMyDatePicker({
    required BuildContext context,
    required Widget child,
    required Function() onCancel,
    required Function() onConfirm,
  }) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                  color: kBackgroundRiceWhite,
                ),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: kPickerCancelGrey,
                          fontSize: 11.sp,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      onPressed: onCancel,
                    ),
                    CupertinoButton(
                      child: Text(
                        'Confirm',
                        style: TextStyle(
                          color: kAutismBridgeBlue,
                          fontSize: 11.sp,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      onPressed: onConfirm,
                    ),
                  ],
                ),
                height: MediaQuery.of(context).copyWith().size.height * 0.06,
              ),
              Container(
                height: MediaQuery.of(context).copyWith().size.height * 0.30,
                color: kBackgroundRiceWhite,
                child: child,
              ),
            ],
          );
        });
  }

  static void showMyCustomizedPicker({
    required BuildContext context,
    required String pickerData,
    required Function(Picker picker, List value) onConfirm,
    required bool smallerText,
  }) {
    Picker(
      height: 30.h,
      itemExtent: 4.h,
      magnification: 1.1,
      confirmTextStyle: TextStyle(
        color: kAutismBridgeBlue,
        fontSize: 11.sp,
      ),
      cancelTextStyle: TextStyle(
        color: kPickerCancelGrey,
        fontSize: 11.sp,
      ),
      textStyle:
          smallerText ? TextStyle(fontSize: 12.sp, color: Colors.black) : null,
      selectedTextStyle: smallerText ? TextStyle(fontSize: 12.sp) : null,
      //textStyle: TextStyle(fontSize: 8.sp),
      backgroundColor: kBackgroundRiceWhite,
      headerDecoration: const BoxDecoration(
        color: kBackgroundRiceWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
      ),
      adapter: PickerDataAdapter<String>(
          pickerdata: const JsonDecoder().convert(pickerData)),
      changeToFirst: true,
      hideHeader: false,
      onConfirm: onConfirm,
    ).showModal(context);
  }

  // Unused Utils
  static showProgressIndicator(BuildContext context) {
    showDialog(
      barrierColor: null,
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          width: 13.h,
          height: 13.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(kCardRadius)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8A959E).withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 30.0,
                //offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox.shrink(),
              SizedBox(
                width: 4.h,
                height: 4.h,
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(
                    kAutismBridgeBlue,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 0.5.h),
                child: const Text(
                  'Loading . . .',
                  style: TextStyle(color: kDarkTextGrey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // As a reference:
    // if (Platform.isIOS) {
    //   showDialog(
    //     barrierColor: Colors.transparent,
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (context) => const Center(
    //       child: CupertinoActivityIndicator(),
    //     ),
    //   );
    // } else {
    //
    // }
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
}
