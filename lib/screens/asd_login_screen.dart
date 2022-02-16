import 'package:autism_bridge/constants.dart';
import 'package:autism_bridge/screens/asd_reset_password_screen.dart';
import 'package:autism_bridge/screens/asd_signup_screen.dart';
import 'package:autism_bridge/widgets/registration_input_field.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:autism_bridge/widgets/registration_button.dart';
import 'package:autism_bridge/widgets/registration_title.dart';
import 'package:sizer/sizer.dart';
import '../main.dart';
import 'package:autism_bridge/widgets/utils.dart';

import 'asd_email_verify_screen.dart';

class AsdLoginScreen extends StatefulWidget {
  static const id = 'asd_login_screen';

  const AsdLoginScreen({Key? key}) : super(key: key);

  @override
  State<AsdLoginScreen> createState() => _AsdLoginScreenState();
}

class _AsdLoginScreenState extends State<AsdLoginScreen> {
  final formKey = GlobalKey<FormState>();

  bool isPasswordHidden = true;

  bool isEmailFieldValid = false;

  bool isPasswordFieldValid = false;

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  void dispose() {
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

  // Log in method
  Future logIn() async {
    // Check if inputs are valid
    final isInputValid = formKey.currentState!.validate();
    if (!isInputValid) return;

    Utils.showProgressIndicator(context);

    try {
      // firebase auth method
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Navigate to asd email verify screen
      Navigator.pushNamedAndRemoveUntil(
          context, AsdEmailVerifyScreen.id, (route) => false);

      // // Navigate to asd user home screen
      // Navigator.pushNamedAndRemoveUntil(
      //     context, AsdHomeScreen.id, (route) => false);
    } on FirebaseAuthException catch (e) {
      navigatorKey.currentState!
          .popUntil(ModalRoute.withName(AsdLoginScreen.id));

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
                    title: 'Log In',
                    subtitle: '',
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
                          color: const Color(0xFF2A6BAC),
                        ),
                        onPressed: _togglePasswordView,
                      ),
                      textInputAction: TextInputAction.done,
                      isObscureText: isPasswordHidden),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 1.5.h, bottom: 1.6.h),
                      child: InkWell(
                        onTap: () => showModalBottomSheet(
                          backgroundColor: const Color(0xFFF0F0F2),
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25.0),
                              topRight: Radius.circular(25.0),
                            ),
                          ),
                          context: context,
                          builder: (context) => SizedBox(
                            height: MediaQuery.of(context).size.height * 0.9,
                            // padding: EdgeInsets.only(
                            //     bottom:
                            //         MediaQuery.of(context).viewInsets.bottom),
                            child: const AsdResetPasswordScreen(),
                          ),
                        ),
                        child: Text(
                          'Forget password?',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: const Color(0xFF858597),
                            fontSize: 9.3.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 1.5.h, right: 1.5.h, top: 1.h, bottom: 3.5.h),
                    child: RegistrationButton(
                      btnName: 'Log In',
                      onPressed: isEmailFieldValid && isPasswordFieldValid
                          ? logIn
                          : null,
                    ),
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      TextSpan(
                        text: 'Don\'t have an account? ',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 8.1.sp,
                          color: const Color(0xFF858597),
                        ),
                      ),
                      TextSpan(
                          text: 'Sign up',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 8.6.sp,
                            color: kAutismBridgeBlue,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Remove all screen from stack except the first screen
                              Navigator.pushNamedAndRemoveUntil(context,
                                  AsdSignupScreen.id, (route) => route.isFirst);
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

// FutureBuilder(
// future: logIn(),
// builder: (context, snapshot) {
// if (!snapshot.hasData) {
// return const CupertinoActivityIndicator();
// } else {
// return const AsdHomeScreen();
// }
// });

// Reference:

// TextFormField(
// keyboardType: TextInputType.emailAddress,
// decoration: InputDecoration(
// labelText: "Email ID",
// labelStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400),
// enabledBorder: OutlineInputBorder(
// borderRadius: BorderRadius.circular(10),
// borderSide: BorderSide(
// color: Colors.grey.shade300,
// ),
// ),
// focusedBorder: OutlineInputBorder(
// borderRadius: BorderRadius.circular(10),
// borderSide: BorderSide(
// color: Colors.red,
// )),
// ),
// // validator: (email) {
// //   if (email.isEmpty)
// //     return 'Please Enter email ID';
// //   else if (!EmailValidator.validate(email))
// //     return 'Enter valid email address';
// //   else
// //     return null;
// // },
// // onSaved: (email)=> _emailID = email,
// textInputAction: TextInputAction.next,
// );
