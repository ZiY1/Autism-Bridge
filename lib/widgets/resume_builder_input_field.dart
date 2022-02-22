import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ResumeBuilderInputField extends StatelessWidget {
  final Function(String?)? onChanged;
  final TextEditingController? myController;
  final String title;
  final String hintText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final String? initialValue;
  final bool? disableBorder;

  const ResumeBuilderInputField({
    Key? key,
    this.myController,
    required this.title,
    required this.hintText,
    required this.keyboardType,
    this.validator,
    required this.textInputAction,
    this.onChanged,
    this.initialValue,
    this.disableBorder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: 1.85.h,
          ),
          child: Text(
            title,
            style: TextStyle(
              color: const Color(0xFF858597),
              fontSize: 10.sp,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.7.h),
          child: TextFormField(
            initialValue: initialValue,
            onChanged: onChanged,
            controller: myController,
            style: TextStyle(
              fontSize: 11.sp,
              color: const Color(0xFF1F1F39),
            ),
            keyboardType: keyboardType,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: validator,
            decoration: InputDecoration(
              //helperText: '',
              filled: true,
              fillColor: Colors.white,
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: 9.5.sp,
                color: Colors.grey.shade400,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 0.2.h,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: disableBorder == true
                      ? Colors.white
                      : const Color(0xFFF0F0F2),
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: disableBorder == true
                      ? Colors.white
                      : const Color(0xFFF0F0F2),
                ),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: disableBorder == true
                      ? Colors.white
                      : const Color(0xFFF0F0F2),
                ),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: disableBorder == true
                      ? Colors.white
                      : const Color(0xFFF0F0F2),
                ),
              ),
              // enabledBorder: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(kResumeBuilderCardRadius),
              //   borderSide: const BorderSide(
              //     color: Color(0xFFF0F0F2),
              //   ),
              // ),
              // focusedBorder: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(kResumeBuilderCardRadius),
              //   borderSide: const BorderSide(
              //     color: Color(0xFFF0F0F2),
              //   ),
              // ),
              // errorBorder: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(kResumeBuilderCardRadius),
              //   borderSide: const BorderSide(
              //     color: Color(0xFFF0F0F2),
              //   ),
              // ),
              // focusedErrorBorder: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(kResumeBuilderCardRadius),
              //   borderSide: const BorderSide(
              //     color: Color(0xFFF0F0F2),
              //   ),
              // ),
            ),
            textInputAction: textInputAction,
          ),
        ),
      ],
    );
  }
}
