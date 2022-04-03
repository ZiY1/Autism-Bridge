import 'package:autism_bridge/color_constants.dart';
import 'package:autism_bridge/models/job_display.dart';
import 'package:autism_bridge/widgets/refresh_widget.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'my_job_card.dart';

class AsdJobBody extends StatefulWidget {
  final List<JobDisplay>? filteredJobList;
  final Future<dynamic> Function() onRefreshCallback;
  final Function(JobDisplay jobDisplay) jobOnPressedCallback;
  const AsdJobBody({
    Key? key,
    required this.filteredJobList,
    required this.onRefreshCallback,
    required this.jobOnPressedCallback,
  }) : super(key: key);

  @override
  State<AsdJobBody> createState() => _AsdJobBodyState();
}

class _AsdJobBodyState extends State<AsdJobBody> {
  List<JobDisplay>? filteredJobList;
  Iterable<JobDisplay>? reversedFilteredJobList;

  @override
  void initState() {
    super.initState();
    filteredJobList = widget.filteredJobList;
    if (widget.filteredJobList != null) {
      reversedFilteredJobList = widget.filteredJobList!.reversed;
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildJobList();
  }

  Widget buildJobList() {
    if (filteredJobList == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (filteredJobList!.isEmpty) {
      return RefreshWidget(
        onRefresh: widget.onRefreshCallback,
        child: ListView(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/undraw_questions.png',
                scale: 2.5,
              ),
              const Text(
                '― No results found ―',
                style: TextStyle(color: kDarkTextGrey),
              ),
            ],
          )
        ]),
      );
    } else {
      return RefreshWidget(
        onRefresh: widget.onRefreshCallback,
        child: ListView.builder(
          padding: EdgeInsets.only(
            left: 1.5.h,
            right: 1.5.h,
            top: 0.5.h,
            bottom: 2.5.h,
          ),
          itemBuilder: (BuildContext context, int index) {
            if (index < widget.filteredJobList!.length) {
              final JobDisplay currentJobDisplay =
                  reversedFilteredJobList!.elementAt(index);
              return MyJobCard(
                companyLogo:
                    currentJobDisplay.recruiterCompanyInfo.companyLogoImage!,
                companyName:
                    currentJobDisplay.recruiterCompanyInfo.companyName!,
                jobName: currentJobDisplay.recruiterJobPost.jobName!,
                jobCity: currentJobDisplay.recruiterJobPost.jobCity!,
                jobState: currentJobDisplay.recruiterJobPost.jobState!,
                employmentType:
                    currentJobDisplay.recruiterJobPost.employmentType!,
                jobOnPressed: () {
                  //TODO:
                  // current index: filteredJobList!.length - index - 1;
                  widget.jobOnPressedCallback(currentJobDisplay);
                },
                bookmarkOnPressed: null,
              );
            } else {
              return Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      '― No more data ―',
                      style: TextStyle(color: kDarkTextGrey),
                    ),
                  ],
                ),
              );
            }
          },
          itemCount: widget.filteredJobList!.length + 1,
          // shrinkWrap: true,
          // primary: false,
          // physics: const NeverScrollableScrollPhysics(),
        ),
      );
    }
  }
}
