import 'package:autism_bridge/apis/resume_pdf_api.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

import '../constants.dart';

class AsdPdfExportScreen extends StatefulWidget {
  final File file;

  final String fileName;

  const AsdPdfExportScreen({
    Key? key,
    required this.file,
    required this.fileName,
  }) : super(key: key);

  @override
  State<AsdPdfExportScreen> createState() => _AsdPdfExportScreenState();
}

class _AsdPdfExportScreenState extends State<AsdPdfExportScreen> {
  final formKey = GlobalKey<FormState>();

  final String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  final emailController = TextEditingController();

  bool isEmailFieldValid = false;

  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundRiceWhite,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: kAutismBridgeBlue,
        title: const Text(
          'Export To Email',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 2.h),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: TextFormField(
                      onChanged: (email) {
                        if (!EmailValidator.validate(email)) {
                          setState(() {
                            isEmailFieldValid = false;
                          });
                        } else {
                          setState(() {
                            isEmailFieldValid = true;
                          });
                        }
                      },
                      controller: emailController,
                      style: TextStyle(
                          fontSize: 10.2.sp, color: const Color(0xFF1F1F39)),
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (email) =>
                          (email != null && !EmailValidator.validate(email))
                              ? 'Enter a valid email'
                              : null,
                      decoration: InputDecoration(
                        helperText: '',
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Enter the destination email address',
                        hintStyle: TextStyle(
                            fontSize: 8.7.sp, color: Colors.grey.shade400),
                        contentPadding: EdgeInsets.symmetric(horizontal: 2.3.h),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: kBackgroundRiceWhite,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: kBackgroundRiceWhite,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: kBackgroundRiceWhite,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: kBackgroundRiceWhite,
                          ),
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                  SizedBox(
                    width: 1.5.h,
                  ),
                  Expanded(
                    flex: 1,
                    child: TextButton(
                      child: Text(
                        'Send',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.white,
                        ),
                      ),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(1.45.h),
                        ),
                        backgroundColor: !isEmailFieldValid
                            ? MaterialStateProperty.all<Color>(
                                kAutismBridgeBlue.withOpacity(0.45),
                              )
                            : MaterialStateProperty.all<Color>(
                                kAutismBridgeBlue,
                              ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      onPressed: isEmailFieldValid
                          ? () {
                              //TODO:
                              print(widget.file.path.toString());
                              // Check if inputs are valid
                              final isInputValid =
                                  formKey.currentState!.validate();
                              if (!isInputValid) return;
                            }
                          : null,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 0.4.h,
              ),
              IntrinsicHeight(
                child: Row(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'images/pdf_icon.png',
                      scale: 4.0,
                    ),
                    SizedBox(width: 3.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.fileName,
                          style:
                              TextStyle(color: Colors.black, fontSize: 12.5.sp),
                        ),
                        Text(
                          currentDate,
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 9.sp,
                          ),
                        ),
                      ],
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
