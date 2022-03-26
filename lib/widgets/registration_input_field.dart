import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../color_constants.dart';

class RegistrationInputField extends StatelessWidget {
  final bool autofocus;
  final Function(String?)? onChanged;
  final TextEditingController? myController;
  final String title;
  final String hintText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final TextInputAction textInputAction;
  final bool isObscureText;

  const RegistrationInputField({
    Key? key,
    required this.autofocus,
    this.myController,
    required this.title,
    required this.hintText,
    required this.keyboardType,
    this.validator,
    required this.suffixIcon,
    required this.textInputAction,
    required this.isObscureText,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.6.h, vertical: 0.7.h),
          child: Text(
            title,
            style: TextStyle(
              color: const Color(0xFF858597),
              fontSize: 9.4.sp,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.5.h),
          child: TextFormField(
            autofocus: autofocus,
            onChanged: onChanged,
            controller: myController,
            style: TextStyle(fontSize: 10.2.sp, color: const Color(0xFF1F1F39)),
            keyboardType: keyboardType,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: validator,
            decoration: InputDecoration(
              helperText: '',
              filled: true,
              fillColor: Colors.white,
              hintText: hintText,
              hintStyle:
                  TextStyle(fontSize: 8.7.sp, color: Colors.grey.shade400),
              // labelText: "Password",
              // labelStyle:
              //     TextStyle(fontSize: 14, color: Colors.grey.shade400),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 1.9.h, horizontal: 2.3.h),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(
                  color: kBackgroundRiceWhite,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(
                  color: kBackgroundRiceWhite,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(
                  color: kBackgroundRiceWhite,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(
                  color: kBackgroundRiceWhite,
                ),
              ),
              suffixIcon: suffixIcon,
            ),
            textInputAction: textInputAction,
            obscureText: isObscureText,
          ),
        ),
      ],
    );
  }
}
