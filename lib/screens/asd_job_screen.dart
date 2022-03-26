import 'package:autism_bridge/models/asd_user_credentials.dart';
import 'package:autism_bridge/models/job_display.dart';
import 'package:autism_bridge/models/job_filter_manager.dart';
import 'package:autism_bridge/models/job_preference_data.dart';
import 'package:autism_bridge/screens/asd_job_view_screen.dart';
import 'package:autism_bridge/widgets/asd_job_app_bar.dart';
import 'package:autism_bridge/widgets/asd_job_body.dart';
import 'package:flutter/material.dart';
import '../color_constants.dart';

class AsdJobScreen extends StatefulWidget {
  static const id = 'asd_job_screen';

  final AsdUserCredentials asdUserCredentials;

  final int currentTabIndex;

  final List<JobPreference?> userJobPreferenceList;

  final List<Tab> tabTextList;

  final Function(int) tabListenerCallback;

  const AsdJobScreen({
    Key? key,
    required this.asdUserCredentials,
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
  final GlobalKey<_AsdJobScreenState> _asdJobScreenState =
      GlobalKey<_AsdJobScreenState>();

  TabController? _tabController;

  List<Widget> jobWidgetList = [];

  void initJobWidgetList() {
    List<Widget> jobWidgetListTemp = [];
    for (int i = 0; i < widget.userJobPreferenceList.length; i++) {
      jobWidgetListTemp.add(AsdJobBody(
        key: UniqueKey(),
        filteredJobList: null,
        onRefreshCallback: buildJobWidgetList,
        jobOnPressedCallback: jobOnPressed,
      ));
    }
    if (!mounted) return;
    setState(() {
      jobWidgetList = jobWidgetListTemp;
    });
  }

  Future<void> buildJobWidgetList() async {
    List<JobDisplay> filteredJobListTemp = [];
    List<Widget> jobWidgetListTemp = [];
    for (int i = 0; i < widget.userJobPreferenceList.length; i++) {
      filteredJobListTemp = await JobFilterManager.filterJobFromFirestore(
          userJobPreferenceList: widget.userJobPreferenceList, index: i);
      jobWidgetListTemp.add(AsdJobBody(
        key: UniqueKey(),
        filteredJobList: filteredJobListTemp,
        onRefreshCallback: buildJobWidgetList,
        jobOnPressedCallback: jobOnPressed,
      ));
    }
    if (!mounted) return;
    setState(() {
      jobWidgetList = jobWidgetListTemp;
    });
  }

  void jobOnPressed(JobDisplay jobDisplay) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AsdJobViewScreen(
              asdUserCredentials: widget.asdUserCredentials,
              jobDisplay: jobDisplay)),
    );
  }

  // TODO: fix this, not working for refresh
  // Future<void> refreshJobWidget() async {
  // }

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

    initJobWidgetList();
    buildJobWidgetList();

    _tabController!.addListener(() {
      if (_tabController!.indexIsChanging) {
        widget.tabListenerCallback(_tabController!.index);
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

    return Scaffold(
      key: _asdJobScreenState,
      backgroundColor: kBackgroundRiceWhite,
      appBar: AsdJobAppBar(
        tabController: _tabController,
        jobTextList: widget.tabTextList,
        appBar: AppBar(),
      ),
      body: TabBarView(
        controller: _tabController,
        children: jobWidgetList,
      ),
    );
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

// Reference: future builder implementation
// children: [
//   // build a list of tabview body in init
//   // for each body pass the corresponding filteredJobList
//   // onRefresh re-fetches the the corresponding filteredJobList and rebuild the widget
//   RefreshWidget(
//     //key: _refreshIndicatorKey,
//     onRefresh: onRefresh,
//     // child: FutureBuilder(
//     //     future: myFuture,
//     //     builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//     //       if (snapshot.hasError) {
//     //         return const Center(
//     //           child: Text('Something went wrong'),
//     //         );
//     //       }
//     //       if (snapshot.hasData && !snapshot.data!.exists) {
//     //         return const Center(
//     //           child: Text('Document does not exist'),
//     //         );
//     //       }
//     //       if (snapshot.connectionState == ConnectionState.done) {
//     //         return buildJobList();
//     //       }
//     //       return const Center(
//     //         child: CircularProgressIndicator(),
//     //       );
//     //     }),
//     child: buildJobList(),
//   ),
// ],
