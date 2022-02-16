import 'dart:io';
import 'package:autism_bridge/constants.dart';
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
}
