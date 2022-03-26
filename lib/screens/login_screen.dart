import 'package:autism_bridge/color_constants.dart';
import 'package:autism_bridge/emums/user_type_enum.dart';
import 'package:autism_bridge/firebase_helpers.dart';
import 'package:autism_bridge/screens/reset_password_screen.dart';
import 'package:autism_bridge/screens/signup_screen.dart';
import 'package:autism_bridge/widgets/registration_input_field.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:autism_bridge/widgets/registration_button.dart';
import 'package:autism_bridge/widgets/registration_title.dart';
import 'package:sizer/sizer.dart';
import 'package:autism_bridge/widgets/utils.dart';
import 'email_verify_screen.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';

  final UserType userType;

  const LoginScreen({
    Key? key,
    required this.userType,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  bool isPasswordHidden = true;

  bool isEmailFieldValid = false;

  bool isPasswordFieldValid = false;

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  bool isLoading = false;

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

    //Utils.showProgressIndicator(context);
    setState(() {
      isLoading = true;
    });

    // Firebase authentication validation
    try {
      // firebase auth method
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      bool isCorrectUser;
      if (widget.userType == UserType.jobSeeker) {
        // Check if the user is in job_seeker_users collection
        // ? I believe  userCredential.user will always be non-null here because if it was null, and exception will be caught
        isCorrectUser = await FirebaseHelper.checkDocumentExists(
            collectionName: 'job_seeker_users',
            docID: userCredential.user!.uid);
      } else {
        isCorrectUser = await FirebaseHelper.checkDocumentExists(
            collectionName: 'recruiter_users', docID: userCredential.user!.uid);
      }

      if (isCorrectUser) {
        // Navigate to asd email verify screen
        Navigator.pushNamedAndRemoveUntil(
            context, EmailVerifyScreen.id, (route) => false);
      } else {
        // navigatorKey.currentState!
        //     .popUntil(ModalRoute.withName(AsdLoginScreen.id));
        setState(() {
          isLoading = false;
        });

        Utils.showSnackBar(
          widget.userType == UserType.jobSeeker
              ? 'There is account is not registered as our job seeker account'
              : 'There is account is not registered as our recruiter account',
          const Icon(
            Icons.error_sharp,
            color: Colors.red,
            size: 30.0,
          ),
        );
        return;
      }
    } on FirebaseAuthException catch (e) {
      // navigatorKey.currentState!
      //     .popUntil(ModalRoute.withName(AsdLoginScreen.id));
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

  void signUpTextBtnOnPressed() {
    // Remove all screen from stack except the first screen
    // Navigator.pushNamedAndRemoveUntil(context,
    //     AsdSignupScreen.id, (route) => route.isFirst);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => SignupScreen(
          userType: widget.userType,
        ),
      ),
      (route) => route.isFirst,
    );
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
                    title: widget.userType == UserType.jobSeeker
                        ? 'Log In'
                        : 'Recruiter Log In',
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
                            child: const ResetPasswordScreen(),
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
                      greyBtn: !(isEmailFieldValid && isPasswordFieldValid),
                      onPressed: isEmailFieldValid &&
                              isPasswordFieldValid &&
                              !isLoading
                          ? logIn
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
                              'Log In',
                              style: TextStyle(
                                fontSize: 12.5.sp,
                                color: Colors.white,
                              ),
                            ),
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
                            signUpTextBtnOnPressed();
                          },
                      ),
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
