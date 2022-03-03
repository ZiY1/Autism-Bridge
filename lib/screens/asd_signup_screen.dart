import 'dart:async';
import 'package:autism_bridge/constants.dart';
import 'package:autism_bridge/screens/asd_email_verify_screen.dart';
import 'package:autism_bridge/screens/asd_login_screen.dart';
import 'package:autism_bridge/widgets/registration_input_field.dart';
import 'package:autism_bridge/widgets/shake_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:autism_bridge/widgets/registration_button.dart';
import 'package:autism_bridge/widgets/registration_title.dart';
import 'package:sizer/sizer.dart';
import 'package:autism_bridge/widgets/utils.dart';

class AsdSignupScreen extends StatefulWidget {
  static const id = 'asd_signup_screen';

  const AsdSignupScreen({Key? key}) : super(key: key);

  @override
  State<AsdSignupScreen> createState() => _AsdSignupScreenState();
}

class _AsdSignupScreenState extends State<AsdSignupScreen> {
  final formKey = GlobalKey<FormState>();

  final shakeKey = GlobalKey<ShakeWidgetState>();

  bool isPasswordHidden = true;

  bool isAgreementChecked = false;

  bool isFirstNameFieldValid = false;

  bool isLastNameFieldValid = false;

  bool isEmailFieldValid = false;

  bool isPasswordFieldValid = false;

  final firstNameController = TextEditingController();

  final lastNameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Show/Hidden password method
  void _togglePasswordView() {
    setState(() {
      isPasswordHidden = !isPasswordHidden;
    });
  }

  // Sign Up method
  Future signUp() async {
    // Check if user checks the agreement box
    if (!isAgreementChecked) {
      shakeKey.currentState?.shake();
      Utils.showSnackBar(
        'Please read and accept our term and condition.',
        const Icon(
          Icons.warning_amber_sharp,
          color: Colors.orangeAccent,
          size: 30.0,
        ),
      );
      return;
    }

    // Check if inputs are valid
    final isInputValid = formKey.currentState!.validate();
    if (!isInputValid) return;

    //Utils.showProgressIndicator(context);
    setState(() {
      isLoading = true;
    });

    try {
      // firebase auth method to create user
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Store user info in firestore all_users collection
      User user = userCredential.user!;
      await FirebaseFirestore.instance
          .collection('all_users')
          .doc(user.uid)
          .set({
        'userType': 'JobSeeker',
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'email': user.email,
      });

      // Store user info in firestore job_seeker_users collection
      await FirebaseFirestore.instance
          .collection('job_seeker_users')
          .doc(user.uid)
          .set({
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'email': user.email,
      });

      // Navigate to asd email verify screen
      Navigator.pushNamedAndRemoveUntil(
        context,
        AsdEmailVerifyScreen.id,
        (route) => false,
      );

      // Navigator.pushNamedAndRemoveUntil(
      //     context, AsdHomeScreen.id, (route) => false);
    } on FirebaseAuthException catch (e) {
      // navigatorKey.currentState!
      //     .popUntil(ModalRoute.withName(AsdSignupScreen.id));
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
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F2),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 1.7.h, right: 1.7.h, top: 4.4.h),
          child: SingleChildScrollView(
            physics: isKeyboardVisible
                ? const ClampingScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            child: Form(
              key: formKey,
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RegistrationTitle(
                    title: 'Sign Up',
                    subtitle: 'Enter your details & free sign up',
                    backOnPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RegistrationInputField(
                            onChanged: (firstName) {
                              if (firstName != null && firstName.isEmpty) {
                                setState(() {
                                  isFirstNameFieldValid = false;
                                });
                              } else {
                                setState(() {
                                  isFirstNameFieldValid = true;
                                });
                              }
                            },
                            autofocus: false,
                            myController: firstNameController,
                            title: 'First Name',
                            hintText: 'Enter your first name',
                            keyboardType: TextInputType.name,
                            validator: (firstName) =>
                                (firstName != null && firstName.isEmpty)
                                    ? 'Enter your first name'
                                    : null,
                            suffixIcon: null,
                            textInputAction: TextInputAction.next,
                            isObscureText: false),
                      ),
                      // SizedBox(
                      //   width: 10.0,
                      // ),
                      Expanded(
                        child: RegistrationInputField(
                            onChanged: (lastName) {
                              if (lastName != null && lastName.isEmpty) {
                                setState(() {
                                  isLastNameFieldValid = false;
                                });
                              } else {
                                setState(() {
                                  isLastNameFieldValid = true;
                                });
                              }
                            },
                            autofocus: false,
                            myController: lastNameController,
                            title: 'Last Name',
                            hintText: 'Enter your last name',
                            keyboardType: TextInputType.name,
                            validator: (lastName) =>
                                (lastName != null && lastName.isEmpty)
                                    ? 'Enter your last name'
                                    : null,
                            suffixIcon: null,
                            textInputAction: TextInputAction.next,
                            isObscureText: false),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 1.h,
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
                      autofocus: false,
                      myController: emailController,
                      title: 'Email Address',
                      hintText: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                      validator: (email) =>
                          (email != null && !EmailValidator.validate(email))
                              ? 'Enter a valid email'
                              : null,
                      suffixIcon: null,
                      textInputAction: TextInputAction.next,
                      isObscureText: false),
                  SizedBox(
                    height: 1.h,
                  ),
                  RegistrationInputField(
                      onChanged: (password) {
                        if (password != null && password.length < 6) {
                          setState(() {
                            isPasswordFieldValid = false;
                          });
                        } else {
                          setState(() {
                            isPasswordFieldValid = true;
                          });
                        }
                      },
                      autofocus: false,
                      myController: passwordController,
                      title: 'Password',
                      hintText: 'Enter your password',
                      keyboardType: TextInputType.text,
                      validator: (password) =>
                          (password != null && password.length < 6)
                              ? 'Enter at least 6 characters'
                              : null,
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordHidden
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: kAutismBridgeBlue,
                        ),
                        onPressed: _togglePasswordView,
                      ),
                      textInputAction: TextInputAction.done,
                      isObscureText: isPasswordHidden),
                  SizedBox(
                    height: 1.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 1.5.h, right: 1.5.h, top: 3.7.h, bottom: 2.h),
                    child: RegistrationButton(
                      greyBtn: !(isFirstNameFieldValid &&
                          isLastNameFieldValid &&
                          isEmailFieldValid &&
                          isPasswordFieldValid),
                      onPressed: isFirstNameFieldValid &&
                              isLastNameFieldValid &&
                              isEmailFieldValid &&
                              isPasswordFieldValid &&
                              !isLoading
                          ? signUp
                          : null,
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
                              'Create account',
                              style: TextStyle(
                                fontSize: 12.5.sp,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 0.65.h, bottom: 1.4.h),
                    child: ShakeWidget(
                      key: shakeKey,
                      shakeCount: 3,
                      shakeOffset: 6,
                      child: Row(
                        children: [
                          Checkbox(
                            value: isAgreementChecked,
                            side: const BorderSide(
                              width: 1.2,
                              color: Color(0xFFB8B8D2),
                            ),
                            onChanged: (value) {
                              setState(() {
                                isAgreementChecked = value!;
                              });
                            },
                            activeColor: kAutismBridgeOrange,
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: [
                              TextSpan(
                                text:
                                    'By creating an account, you have to agree with our ',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 8.1.sp,
                                  color: const Color(0xFF858597),
                                ),
                              ),
                              TextSpan(
                                  text: 'term',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 8.6.sp,
                                    color: const Color(0xFF2A6BAC),
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // TODO:
                                    }),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 8.1.sp,
                          color: const Color(0xFF858597),
                        ),
                      ),
                      TextSpan(
                          text: 'Log In',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 8.6.sp,
                            color: const Color(0xFF2A6BAC),
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Remove all screen from stack except the first screen
                              Navigator.pushNamedAndRemoveUntil(context,
                                  AsdLoginScreen.id, (route) => route.isFirst);
                            }),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
