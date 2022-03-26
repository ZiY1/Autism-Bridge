import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';
import '../color_constants.dart';

class ResumeDateToggle extends StatelessWidget {
  final bool isDatePresent;

  final Function(bool)? onChanged;

  final String toggleText;

  const ResumeDateToggle({
    Key? key,
    required this.isDatePresent,
    required this.onChanged,
    required this.toggleText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform.scale(
          scale: 0.65,
          child: CupertinoSwitch(
            activeColor: kAutismBridgeBlue,
            value: isDatePresent,
            onChanged: onChanged,
          ),
        ),
        Text(
          toggleText,
          style: TextStyle(
            fontSize: 9.5.sp,
            color: const Color(0xFF1F1F39),
          ),
        ),
      ],
    );
  }
}
