import 'package:autism_bridge/models/job_display.dart';
import 'package:autism_bridge/models/job_preference_data.dart';
import 'package:autism_bridge/models/recruiter_company_info.dart';
import 'package:autism_bridge/models/recruiter_job_post.dart';
import 'package:autism_bridge/widgets/asd_job_app_bar.dart';
import 'package:autism_bridge/widgets/my_job_card.dart';
import 'package:autism_bridge/widgets/refresh_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../constants.dart';

class AsdJobScreen extends StatefulWidget {
  static const id = 'asd_job_screen';

  final int currentTabIndex;

  final List<JobPreference?> userJobPreferenceList;

  final List<Tab> tabTextList;

  final Function(int) tabListenerCallback;

  const AsdJobScreen({
    Key? key,
    required this.currentTabIndex,
    required this.userJobPreferenceList,
    required this.tabTextList,
    required this.tabListenerCallback,
  }) : super(key: key);

  @override
  _AsdJobScreenState createState() => _AsdJobScreenState();
}

class _AsdJobScreenState extends State<AsdJobScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<_AsdJobScreenState> _asdJobScreenState =
      GlobalKey<_AsdJobScreenState>();

  TabController? _tabController;

  List<JobDisplay> filteredJobList = [];

  Future? myFuture;

  Future<void> filterJobFromFirestore() async {
    // TODO: modified where you store the min max salary to store integers rather than string

    // 1. Read the RecruiterJobPost by filtering with JobPreference
    // 2. For each RecruiterJobPost, fetch its corresponding RecruiterCompanyInfo
    //    if there is no key in the map, then store it in an map
    //    {key: docId, value: RecruiterCompanyInfo}.
    //    Otherwise, use the value of the key.
    // 3. Create a Job class containing RecruiterJobPost with its corresponding

    //List<JobDisplay> filteredJobDisplayList = [];

    //TODO: create a map for recruiterCompanyInfo

    //TODO: implement the salary condition
    // If these two condition are not specific, no need to make them as a condition
    if (widget.userJobPreferenceList[_tabController!.index]!
                .getEmploymentType ==
            'Any Type' &&
        widget.userJobPreferenceList[_tabController!.index]!.getMinSalary ==
            'None') {
      await FirebaseFirestore.instance
          .collection("all_jobs")
          .where('jobCategory',
              isEqualTo: widget
                  .userJobPreferenceList[_tabController!.index]!.getJobCategory)
          .where('jobTitle',
              isEqualTo: widget
                  .userJobPreferenceList[_tabController!.index]!.getJobTitle)
          .where('jobState',
              isEqualTo: widget
                  .userJobPreferenceList[_tabController!.index]!.getJobState)
          .where('jobCity',
              isEqualTo: widget
                  .userJobPreferenceList[_tabController!.index]!.getJobCity)
          .get()
          .then((querySnapshot) async {
        for (var singleJob in querySnapshot.docs) {
          //print(singleJob.data()['jobName']);
          var singleJobData = singleJob.data();

          // Read all fields
          String userId = singleJobData['collectionId'];
          String subCollectionId = singleJobData['subCollectionId'];
          String employmentType = singleJobData['employmentType'];
          String jobName = singleJobData['jobName'];
          String jobCategory = singleJobData['jobCategory'];
          String jobTitle = singleJobData['jobTitle'];
          String jobCity = singleJobData['jobCity'];
          String jobState = singleJobData['jobState'];
          String jobAddress = singleJobData['jobAddress'];
          String minExperience = singleJobData['minExperience'];
          String minEducation = singleJobData['minEducation'];
          String minSalary = singleJobData['minSalary'];
          String maxSalary = singleJobData['maxSalary'];
          String jobDescription = singleJobData['jobDescription'];

          // Create a RecruiterJobPost class
          RecruiterJobPost recruiterJobPostTemp = RecruiterJobPost(
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

          // Fetch the corresponding RecruiterCompanyInfo
          // TODO: add exception handling
          RecruiterCompanyInfo? recruiterCompanyInfoTemp =
              await RecruiterCompanyInfo.readRecruiterCompanyInfoFromFirestore(
                  userId);

          // Create a jobDisplay class
          JobDisplay jobDisplayTemp = JobDisplay(
              recruiterJobPost: recruiterJobPostTemp,
              recruiterCompanyInfo: recruiterCompanyInfoTemp!);

          // add the jobDisplay class to the list
          filteredJobList.add(jobDisplayTemp);
        }
      });
    }
    // If jobSeekerJobPreference.getEmploymentType is 'Any Type', no need to make it as a condition
    else if (widget
            .userJobPreferenceList[_tabController!.index]!.getEmploymentType ==
        'Any Type') {
      FirebaseFirestore.instance
          .collection("all_jobs")
          .where('jobCategory',
              isEqualTo: widget
                  .userJobPreferenceList[_tabController!.index]!.getJobCategory)
          .where('jobTitle',
              isEqualTo: widget
                  .userJobPreferenceList[_tabController!.index]!.getJobTitle)
          .where('jobState',
              isEqualTo: widget
                  .userJobPreferenceList[_tabController!.index]!.getJobState)
          .where('jobCity',
              isEqualTo: widget
                  .userJobPreferenceList[_tabController!.index]!.getJobCity)
          .get()
          .then((querySnapshot) {
        for (var singleJob in querySnapshot.docs) {
          print(singleJob.data()['jobName']);
        }
      });
    }
    // If jobSeekerJobPreference.getMinSalary is 'Any Type', no need to make it as a condition
    else if (widget
            .userJobPreferenceList[_tabController!.index]!.getMinSalary ==
        'None') {
      FirebaseFirestore.instance
          .collection("all_jobs")
          .where('employmentType',
              isEqualTo: widget.userJobPreferenceList[_tabController!.index]!
                  .getEmploymentType)
          .where('jobCategory',
              isEqualTo: widget
                  .userJobPreferenceList[_tabController!.index]!.getJobCategory)
          .where('jobTitle',
              isEqualTo: widget
                  .userJobPreferenceList[_tabController!.index]!.getJobTitle)
          .where('jobState',
              isEqualTo: widget
                  .userJobPreferenceList[_tabController!.index]!.getJobState)
          .where('jobCity',
              isEqualTo: widget
                  .userJobPreferenceList[_tabController!.index]!.getJobCity)
          .get()
          .then((querySnapshot) {
        for (var singleJob in querySnapshot.docs) {
          print(singleJob.data()['jobName']);
        }
      });
    }
    // Every preference is specific
    else {
      FirebaseFirestore.instance
          .collection("all_jobs")
          .where('employmentType',
              isEqualTo: widget.userJobPreferenceList[_tabController!.index]!
                  .getEmploymentType)
          .where('jobCategory',
              isEqualTo: widget
                  .userJobPreferenceList[_tabController!.index]!.getJobCategory)
          .where('jobTitle',
              isEqualTo: widget
                  .userJobPreferenceList[_tabController!.index]!.getJobTitle)
          .where('jobState',
              isEqualTo: widget
                  .userJobPreferenceList[_tabController!.index]!.getJobState)
          .where('jobCity',
              isEqualTo: widget
                  .userJobPreferenceList[_tabController!.index]!.getJobCity)
          .get()
          .then((querySnapshot) {
        for (var singleJob in querySnapshot.docs) {
          print(singleJob.data()['jobName']);
        }
      });
    }
  }

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

    setState(() {
      myFuture = filterJobFromFirestore();
    });

    _tabController!.addListener(() {
      if (_tabController!.indexIsChanging) {
        widget.tabListenerCallback(_tabController!.index);
        setState(() {
          filteredJobList = [];
          myFuture = filterJobFromFirestore();
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // setState(() {
    //   filteredJobList = [];
    //   myFuture = filterJobFromFirestore();
    // });

    return Scaffold(
      key: _asdJobScreenState,
      backgroundColor: kBackgroundRiceWhite,
      appBar: AsdJobAppBar(
        tabController: _tabController,
        jobTextList: widget.tabTextList,
        appBar: AppBar(),
      ),
      body: RefreshWidget(
        key: _refreshIndicatorKey,
        onRefresh: onRefresh,
        child: FutureBuilder(
            future: myFuture,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: SafeArea(
                      child: Column(
                    children: const [Text('Something went wrong')],
                  )),
                );
              }
              if (snapshot.hasData && !snapshot.data!.exists) {
                return Scaffold(
                  body: SafeArea(
                      child: Column(
                    children: const [Text('Document does not exist')],
                  )),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return buildJobList();
              }
              return const Scaffold(
                body: SafeArea(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }),
      ),
    );
  }

  Future onRefresh() async {
    setState(() {
      filteredJobList = [];
      myFuture = filterJobFromFirestore();
    });
  }

  Widget buildJobList() {
    if (filteredJobList.isEmpty) {
      return const Center(child: Text('List Empty'));
    } else {
      return ListView.builder(
        padding: EdgeInsets.only(
          left: 1.5.h,
          right: 1.5.h,
          top: 0.5.h,
          bottom: 2.5.h,
        ),
        itemBuilder: (BuildContext context, int index) {
          final JobDisplay currentJobDisplay = filteredJobList[index];
          return MyJobCard(
              companyLogo:
                  currentJobDisplay.recruiterCompanyInfo.companyLogoImage!,
              companyName: currentJobDisplay.recruiterCompanyInfo.companyName!,
              jobName: currentJobDisplay.recruiterJobPost.jobName!,
              jobCity: currentJobDisplay.recruiterJobPost.jobCity!,
              jobState: currentJobDisplay.recruiterJobPost.jobState!,
              employmentType:
                  currentJobDisplay.recruiterJobPost.employmentType!,
              jobOnPressed: null,
              bookmarkOnPressed: null);
        },
        itemCount: filteredJobList.length,
        // shrinkWrap: true,
        // primary: false,
// physics: const NeverScrollableScrollPhysics(),
      );
    }
  }
}

// Testing btn
// ElevatedButton(
// onPressed: () {
// JobFilterManager.filterJobFromFirestore(
// jobSeekerJobPreference: widget.userJobPreference);
// },
// child: const Text('Job Filter Testing btn'),
// ),

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
