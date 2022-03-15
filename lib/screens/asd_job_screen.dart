import 'package:autism_bridge/models/job_filter_manager.dart';
import 'package:autism_bridge/models/job_preference_data.dart';
import 'package:autism_bridge/models/recruiter_company_info.dart';
import 'package:autism_bridge/models/recruiter_job_post.dart';
import 'package:autism_bridge/models/resume_data.dart';
import 'package:autism_bridge/widgets/asd_job_app_bar.dart';
import 'package:autism_bridge/widgets/my_job_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../constants.dart';

class AsdJobScreen extends StatefulWidget {
  static const id = 'asd_job_screen';

  final int currentTabIndex;

  final JobPreference userJobPreference;

  final List<Tab> tabTextList;

  final Function(int) tabListenerCallback;

  // Delete later, testing only
  final Resume userResume;

  const AsdJobScreen({
    Key? key,
    required this.currentTabIndex,
    required this.userJobPreference,
    required this.tabTextList,
    required this.tabListenerCallback,
    required this.userResume,
  }) : super(key: key);

  @override
  _AsdJobScreenState createState() => _AsdJobScreenState();
}

class _AsdJobScreenState extends State<AsdJobScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final _firestore = FirebaseFirestore.instance;

  TabController? _tabController;

  List<RecruiterJobPost?>? filteredJobList;

  // The Mixin AutomaticKeepAliveClientMixin is used to preserve the state of the tab
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabTextList.length,
      initialIndex: widget.currentTabIndex,
      vsync: this,
    );
    _tabController!.addListener(() {
      widget.tabListenerCallback(_tabController!.index);
    });

    // filteredJobList = JobFilterManager.filterJobFromFirestore(
    //     jobPreference: widget.userJobPreference) as List<RecruiterJobPost?>?;
    // print(filteredJobList![0]!.jobName);
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: kBackgroundRiceWhite,
      appBar: AsdJobAppBar(
        tabController: _tabController,
        jobTextList: widget.tabTextList,
        appBar: AppBar(),
      ),
      // child: ListView.builder(
      //   itemBuilder: (BuildContext context, int index) {
      //     return Center(child: Text(widget.userJobPreference.getJobTitle));
      //   },
      //   itemCount: 0,
      //   // shrinkWrap: true,
      //   // physics: const NeverScrollableScrollPhysics(),
      // ),
      // body: Center(
      //   child: Text(widget.userJobPreference.getJobTitle),
      // ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('all_jobs').snapshots(),
        builder: (context, snapshot) {
          // This snapshot is an AsyncSnapshot not QuerySnapshot, but it contains QuerySnapshot

          // When snapshot has no data:
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // As soon as snapshot has data:
          // in order to access the .docs property, we need to specify that we have a StreamBuilder of QuerySnapshot
          final jobs = snapshot.data!.docs.reversed;
          List<RecruiterJobPost> jobList = [];
          for (var job in jobs) {
            final String userId = job['collectionId'];
            final String subCollectionId = job['subCollectionId'];
            final String jobName = job['jobName'];
            final String employmentType = job['employmentType'];
            final String jobCategory = job['jobCategory'];
            final String jobTitle = job['jobTitle'];
            final String jobCity = job['jobCity'];
            final String jobState = job['jobState'];
            final String jobAddress = job['jobAddress'];
            final String minExperience = job['minExperience'];
            final String minEducation = job['minEducation'];
            final String minSalary = job['minSalary'];
            final String maxSalary = job['maxSalary'];
            final String jobDescription = job['jobDescription'];

            final RecruiterJobPost recruiterJobPost = RecruiterJobPost(
                userId: userId,
                subCollectionId: subCollectionId,
                employmentType: employmentType,
                jobName: jobName,
                jobCategory: jobCategory,
                jobTitle: jobTitle,
                jobCity: jobCity,
                jobState: jobState,
                jobAddress: jobAddress,
                minExperience: minExperience,
                minEducation: minEducation,
                minSalary: minSalary,
                maxSalary: maxSalary,
                jobDescription: jobDescription);

            jobList.add(recruiterJobPost);
          }
          return ListView.builder(
            padding: EdgeInsets.only(
              left: 1.5.h,
              right: 1.5.h,
              top: 0.5.h,
              bottom: 2.5.h,
            ),
            itemBuilder: (BuildContext context, int index) {
              final RecruiterJobPost currentRecruiterJobPost = jobList[index];
              return MyJobCard(
                  companyLogo:
                      widget.userResume.userPersonalDetails!.profileImage,
                  companyName: 'Fake Data',
                  jobName: currentRecruiterJobPost.jobName!,
                  jobCity: currentRecruiterJobPost.jobCity!,
                  jobState: currentRecruiterJobPost.jobState!,
                  employmentType: currentRecruiterJobPost.employmentType!,
                  jobOnPressed: null,
                  bookmarkOnPressed: null);
            },
            itemCount: jobList.length,
// shrinkWrap: true,
// physics: const NeverScrollableScrollPhysics(),
          );
        },
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

// return ListView.builder(
// padding: EdgeInsets.only(
// left: 1.5.h,
// right: 1.5.h,
// top: 0.5.h,
// bottom: 2.5.h,
// ),
// itemBuilder: (BuildContext context, int index) {
// final RecruiterJobPost currentRecruiterJobPost = jobList[index];
// return MyJobCard(
// companyLogo: ,
// companyName: ,
// jobName: currentRecruiterJobPost.jobName!,
// jobCity: currentRecruiterJobPost.jobCity!,
// jobState: currentRecruiterJobPost.jobState!,
// employmentType: currentRecruiterJobPost.employmentType!,
// jobOnPressed: null,
// bookmarkOnPressed: null);
// },
// itemCount: jobList.length,
// // shrinkWrap: true,
// // physics: const NeverScrollableScrollPhysics(),
// );
