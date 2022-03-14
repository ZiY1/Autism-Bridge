import 'package:autism_bridge/models/job_preference_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AsdJobScreen extends StatefulWidget {
  static const id = 'asd_job_screen';

  final JobPreference userJobPreference;

  const AsdJobScreen({Key? key, required this.userJobPreference})
      : super(key: key);

  @override
  _AsdJobScreenState createState() => _AsdJobScreenState();
}

class _AsdJobScreenState extends State<AsdJobScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // child: ListView.builder(
      //   itemBuilder: (BuildContext context, int index) {
      //     return Center(child: Text(widget.userJobPreference.getJobTitle));
      //   },
      //   itemCount: 0,
      //   // shrinkWrap: true,
      //   // physics: const NeverScrollableScrollPhysics(),
      // ),
      child: Center(
        child: Text(widget.userJobPreference.getJobTitle),
      ),
    );
  }
}

// ListView Padding
// padding: EdgeInsets.only(
// left: 1.5.h,
// right: 1.5.h,
// top: 0.5.h,
// bottom: 2.5.h,
// ),
