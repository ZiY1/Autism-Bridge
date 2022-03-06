import 'package:autism_bridge/models/asd_user_credentials.dart';
import 'package:autism_bridge/models/resume_data.dart';
import 'package:autism_bridge/widgets/my_gradient_container.dart';
import 'package:autism_bridge/widgets/rounded_icon_container.dart';
import 'package:autism_bridge/widgets/utils.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:io';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

import '../constants.dart';

class AsdPdfExportScreen extends StatefulWidget {
  final AsdUserCredentials asdUserCredentials;

  final File file;

  final String fileName;

  final Resume userResume;

  const AsdPdfExportScreen({
    Key? key,
    required this.asdUserCredentials,
    required this.file,
    required this.fileName,
    required this.userResume,
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

  /// This works with emailjs, however sending attachments is charged
  // Future sendEmail(
  //     {required String name,
  //     required String email,
  //     required String subject,
  //     required String message}) async {
  //   const serviceId = 'service_jw3wp5o';
  //   const templateId = 'template_n4dj8eq';
  //   const userId = 'user_cXTtBgxWArO3N7mt8zfcd';
  //
  //   try {
  //     final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  //     final response = await http.post(
  //       url,
  //       headers: {
  //         'origin': 'http://localhost',
  //         'Content-Type': 'application/json',
  //       },
  //       body: json.encode({
  //         'service_id': serviceId,
  //         'template_id': templateId,
  //         'user_id': userId,
  //         'template_params': {
  //           'user_name': name,
  //           'user_email': email,
  //           'user_subject': subject,
  //           'user_message': message,
  //         },
  //       }),
  //     );
  //
  //     emailController.clear();
  //     isEmailFieldValid = false;
  //
  //     Utils.showSnackBar(
  //       'Email send!',
  //       const Icon(
  //         Icons.mark_email_read_sharp,
  //         color: Colors.green,
  //         size: 30.0,
  //       ),
  //     );
  //   } catch (e) {
  //     Utils.showSnackBar(
  //       e.toString(),
  //       const Icon(
  //         Icons.error_sharp,
  //         color: Colors.red,
  //         size: 30.0,
  //       ),
  //     );
  //   }
  //
  //   //print(response.body);
  // }

  Future sendEmail(
      {required String name,
      required String email,
      required String subject,
      required String msgText}) async {
    const emailSender = 'autismbridge@zahncenternyc.com';
    const emailSenderPassword = 'Capstone123';

    final smtpServer = gmail(emailSender, emailSenderPassword);
    final message = Message()
      ..from = const Address(emailSender, 'Autism Bridge Team')
      ..recipients = [email]
      ..subject = subject
      ..text = msgText
      ..attachments = [FileAttachment(widget.file)];

    isEmailFieldValid = false;

    Utils.showSnackBar(
      'Email send!',
      const Icon(
        Icons.mark_email_read_sharp,
        color: Colors.green,
        size: 30.0,
      ),
    );

    try {
      await send(message, smtpServer);
    } on MailerException catch (e) {
      Utils.showSnackBar(
        e.message,
        const Icon(
          Icons.error_sharp,
          color: Colors.red,
          size: 30.0,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyGradientContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: const Text(
            'Export To Email',
            style: TextStyle(
              color: kTitleBlack,
            ),
          ),
          iconTheme: const IconThemeData(
            color: kTitleBlack,
          ),
          leading: RoundedIconContainer(
            childIcon: const Icon(
              Icons.close_rounded,
              color: kTitleBlack,
              size: 20,
            ),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            margin: EdgeInsets.all(1.35.h),
          ),
          leadingWidth: 14.8.w,
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
                      flex: 4,
                      child: TextFormField(
                        autofocus: true,
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
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 2.3.h),
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
                                //print(widget.file.path.toString());
                                // Check if inputs are valid
                                final isInputValid =
                                    formKey.currentState!.validate();
                                if (!isInputValid) return;
                                sendEmail(
                                    name:
                                        '${widget.userResume.userPersonalDetails!.firstName} ${widget.userResume.userPersonalDetails!.lastName}',
                                    email: emailController.text.trim(),
                                    subject: 'Resume Builder Export PDF Test',
                                    msgText: 'This is a test');
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
                            style: TextStyle(
                                color: Colors.black, fontSize: 12.5.sp),
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
      ),
    );
  }
}
