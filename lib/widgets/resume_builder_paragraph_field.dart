import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../color_constants.dart';

class ResumeBuilderParagraphField extends StatelessWidget {
  final String title;

  final ScrollController _scrollController;

  final Function(String) onChanged;

  final bool autoFocus;

  final int minLines;

  final int maxLines;

  final String hintText;

  final int textLen;

  final String? initialValue;

  const ResumeBuilderParagraphField({
    Key? key,
    required this.title,
    required this.onChanged,
    required this.autoFocus,
    required this.minLines,
    required this.maxLines,
    required this.hintText,
    required ScrollController scrollController,
    required this.textLen,
    required this.initialValue,
  })  : _scrollController = scrollController,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 0.3.h),
          child: Text(
            title,
            style: TextStyle(
              color: const Color(0xFF858597),
              fontSize: 10.sp,
            ),
          ),
        ),
        Scrollbar(
          controller: _scrollController,
          isAlwaysShown: false,
          child: TextFormField(
            initialValue: initialValue,
            onChanged: onChanged,
            scrollController: _scrollController,
            autofocus: autoFocus,
            style: TextStyle(
              fontSize: 11.sp,
              color: const Color(0xFF1F1F39),
            ),
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.done,
            minLines: minLines,
            maxLines: maxLines,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: 9.5.sp,
                color: Colors.grey.shade400,
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 2.h,
                horizontal: 0.2.h,
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFF0F0F2),
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFF0F0F2),
                ),
              ),
              errorBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFF0F0F2),
                ),
              ),
              focusedErrorBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFF0F0F2),
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
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 1.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '$textLen',
                style: TextStyle(
                  color: kAutismBridgeBlue,
                  fontSize: 10.sp,
                ),
              ),
              Text(
                '/ 300+',
                style: TextStyle(
                  color: const Color(0xFF858597),
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
