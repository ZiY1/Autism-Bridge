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
            children: const [
              Center(
                child: Text('List Empty'),
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
                bookmarkOnPressed: null);
          },
          itemCount: widget.filteredJobList!.length,
          // shrinkWrap: true,
          // primary: false,
          // physics: const NeverScrollableScrollPhysics(),
        ),
      );
    }
  }
}
