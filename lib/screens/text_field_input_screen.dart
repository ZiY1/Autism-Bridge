import 'package:autism_bridge/widgets/my_gradient_container.dart';
import 'package:autism_bridge/widgets/rounded_icon_container.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../color_constants.dart';
import '../num_constants.dart';

class TextFieldInputScreen extends StatefulWidget {
  final String title;
  final String? userInput;
  final String hintText;
  final TextInputType keyBoardType;

  const TextFieldInputScreen({
    Key? key,
    this.userInput,
    required this.title,
    required this.hintText,
    required this.keyBoardType,
  }) : super(key: key);

  @override
  _TextFieldInputScreenState createState() => _TextFieldInputScreenState();
}

class _TextFieldInputScreenState extends State<TextFieldInputScreen> {
  @override
  Widget build(BuildContext context) {
    return MyGradientContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: Text(
            widget.title,
            style: const TextStyle(
              color: kTitleBlack,
            ),
          ),
          iconTheme: const IconThemeData(
            color: kTitleBlack,
          ),
          leading: RoundedIconContainer(
            childIcon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: kTitleBlack,
              size: 20,
            ),
            color: Colors.white,
            onPressed: () {
              //TODO:
              Navigator.pop(context);
            },
            margin: EdgeInsets.all(1.35.h),
          ),
          leadingWidth: 14.8.w,
          actions: [
            Padding(
              padding:
                  EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 1.85.h),
              child: GestureDetector(
                onTap: () {
                  //TODO:
                },
                child: Container(
                  width: 14.w,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  child: const Center(
                    child: Text(
                      'Save',
                      style: TextStyle(color: kTitleBlack),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 1.7.h, vertical: 2.h),
                child: TextFormField(
                  initialValue: widget.userInput,
                  onChanged: (text) {},
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF1F1F39),
                  ),
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  //validator: validator,
                  decoration: InputDecoration(
                    //helperText: '',
                    filled: true,
                    fillColor: Colors.white,
                    hintText: widget.hintText,
                    hintStyle: TextStyle(
                      fontSize: 9.5.sp,
                      color: Colors.grey.shade400,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 1.8.h,
                      vertical: 1.5.h,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(kCardRadius),
                      borderSide: const BorderSide(
                        color: Color(0xFFF0F0F2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(kCardRadius),
                      borderSide: const BorderSide(
                        color: Color(0xFFF0F0F2),
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(kCardRadius),
                      borderSide: const BorderSide(
                        color: Color(0xFFF0F0F2),
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(kCardRadius),
                      borderSide: const BorderSide(
                        color: Color(0xFFF0F0F2),
                      ),
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
