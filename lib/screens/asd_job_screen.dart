import 'package:autism_bridge/models/job_preference_data.dart';
import 'package:autism_bridge/widgets/asd_job_app_bar.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class AsdJobScreen extends StatefulWidget {
  static const id = 'asd_job_screen';

  final int currentTabIndex;

  final JobPreference userJobPreference;

  final List<Tab> tabTextList;

  final Function(int) tabListenerCallback;

  const AsdJobScreen(
      {Key? key,
      required this.currentTabIndex,
      required this.userJobPreference,
      required this.tabTextList,
      required this.tabListenerCallback})
      : super(key: key);

  @override
  _AsdJobScreenState createState() => _AsdJobScreenState();
}

class _AsdJobScreenState extends State<AsdJobScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController? _tabController;

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
      body: Center(
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
