import 'package:autism_bridge/widgets/registration_button.dart';
import 'package:autism_bridge/widgets/registration_input_field.dart';
import 'package:autism_bridge/widgets/registration_title.dart';
import 'package:autism_bridge/widgets/utils.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'asd_login_screen.dart';
import 'package:sizer/sizer.dart';

class AsdResetPasswordScreen extends StatefulWidget {
  const AsdResetPasswordScreen({Key? key}) : super(key: key);

  @override
  _AsdResetPasswordScreenState createState() => _AsdResetPasswordScreenState();
}

class _AsdResetPasswordScreenState extends State<AsdResetPasswordScreen> {
  final formKey = GlobalKey<FormState>();

  bool isEmailFieldValid = false;

  final emailController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future resetPassword() async {
    // Check if inputs are valid
    final isInputValid = formKey.currentState!.validate();
    if (!isInputValid) return;

    //Utils.showProgressIndicator(context);
    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      Utils.showSnackBar(
        'Password reset email sent, please follow the link on the email to reset your password.',
        const Icon(
          Icons.mark_email_read_sharp,
          color: Colors.green,
          size: 30.0,
        ),
      );

      // On success, return to login page
      navigatorKey.currentState!
          .popUntil(ModalRoute.withName(AsdLoginScreen.id));
    } on FirebaseAuthException catch (e) {
      //Navigator.of(context).pop();
      setState(() {
        isLoading = false;
      });

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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.only(left: 1.7.h, right: 1.7.h, top: 4.4.h),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RegistrationTitle(
                  title: 'Reset Password',
                  subtitle:
                      'Follow the link on the email to reset your password',
                  backOnPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  height: 5.h,
                ),
                RegistrationInputField(
                    onChanged: (email) {
                      if (email != null && !EmailValidator.validate(email)) {
                        setState(() {
                          isEmailFieldValid = false;
                        });
                      } else {
                        setState(() {
                          isEmailFieldValid = true;
                        });
                      }
                    },
                    autofocus: true,
                    myController: emailController,
                    title: 'Email Address',
                    hintText: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                    validator: (email) =>
                        email != null && !EmailValidator.validate(email)
                            ? 'Enter a valid email'
                            : null,
                    suffixIcon: null,
                    textInputAction: TextInputAction.done,
                    isObscureText: false),
                Padding(
                  padding: EdgeInsets.only(left: 1.5.h, right: 1.5.h, top: 3.h),
                  child: RegistrationButton(
                    greyBtn: !isEmailFieldValid,
                    icon: const Icon(
                      Icons.email_sharp,
                      color: Colors.white,
                    ),
                    onPressed: isEmailFieldValid ? resetPassword : null,
                    child: isLoading
                        ? SizedBox(
                            width: 3.18.h,
                            height: 3.18.h,
                            child: const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            'Send Email',
                            style: TextStyle(
                              fontSize: 12.5.sp,
                              color: Colors.white,
                            ),
                          ),
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
