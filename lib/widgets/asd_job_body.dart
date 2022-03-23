import 'package:autism_bridge/models/job_display.dart';
import 'package:autism_bridge/widgets/refresh_widget.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'my_job_card.dart';

class AsdJobBody extends StatefulWidget {
  final List<JobDisplay>? filteredJobList;
  final Future<dynamic> Function() onRefreshCallback;
  const AsdJobBody({
    Key? key,
    required this.filteredJobList,
    required this.onRefreshCallback,
  }) : super(key: key);

  @override
  State<AsdJobBody> createState() => _AsdJobBodyState();
}

class _AsdJobBodyState extends State<AsdJobBody> {
  @override
  Widget build(BuildContext context) {
    return buildJobList();
  }

  Widget buildJobList() {
    if (widget.filteredJobList == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (widget.filteredJobList!.isEmpty) {
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
            final JobDisplay currentJobDisplay = widget.filteredJobList![index];
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
                jobOnPressed: null,
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
