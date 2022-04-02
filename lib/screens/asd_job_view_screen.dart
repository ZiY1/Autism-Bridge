import 'package:autism_bridge/models/asd_user_credentials.dart';
import 'package:autism_bridge/models/job_display.dart';
import 'package:autism_bridge/models/recruiter_company_info.dart';
import 'package:autism_bridge/models/recruiter_job_post.dart';
import 'package:autism_bridge/models/recruiter_profile.dart';
import 'package:autism_bridge/widgets/my_card_widget.dart';
import 'package:autism_bridge/widgets/my_gradient_container.dart';
import 'package:autism_bridge/widgets/resume_builder_button.dart';
import 'package:autism_bridge/widgets/rounded_icon_container.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../color_constants.dart';
import '../num_constants.dart';

class AsdJobViewScreen extends StatefulWidget {
  final AsdUserCredentials asdUserCredentials;

  final JobDisplay jobDisplay;

  const AsdJobViewScreen({
    Key? key,
    required this.asdUserCredentials,
    required this.jobDisplay,
  }) : super(key: key);

  @override
  _AsdJobViewScreenState createState() => _AsdJobViewScreenState();
}

class _AsdJobViewScreenState extends State<AsdJobViewScreen>
    with SingleTickerProviderStateMixin {
  late final RecruiterProfile recruiterProfile;
  late final RecruiterCompanyInfo recruiterCompanyInfo;
  late final RecruiterJobPost recruiterJobPost;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    recruiterProfile = widget.jobDisplay.recruiterProfile;
    recruiterCompanyInfo = widget.jobDisplay.recruiterCompanyInfo;
    recruiterJobPost = widget.jobDisplay.recruiterJobPost;
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyGradientContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: Text(
            recruiterCompanyInfo.companyName!,
            style: const TextStyle(
              //fontWeight: FontWeight.w600,
              //letterSpacing: 0.6,
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
              Navigator.pop(context);
            },
            margin: EdgeInsets.all(1.35.h),
          ),
          leadingWidth: 14.8.w,
        ),
        body: ListView(
          padding: EdgeInsets.only(
            // left: 1.5.h,
            // right: 1.5.h,
            bottom: 2.5.h,
          ),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 2.h,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0), //or 15.0
                      child: Container(
                        height: 10.h,
                        width: 10.h,
                        color: kBackgroundRiceWhite,
                        child: FittedBox(
                          child: Image.file(
                              recruiterCompanyInfo.companyLogoImage!),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 1.8.h,
                    ),
                    Text(
                      recruiterJobPost.jobName!,
                      style: TextStyle(
                        color: kTitleBlack,
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Text(
                      recruiterJobPost.maxSalary! == kEmpty
                          ? recruiterJobPost.minSalary == kNone
                              ? '\$ Not Specified'
                              : recruiterJobPost.minSalary == kMinSalaryLimit
                                  ? '< \$${recruiterJobPost.minSalary}K'
                                  : '> \$${recruiterJobPost.minSalary}K'
                          : '\$${recruiterJobPost.minSalary}K - \$${recruiterJobPost.maxSalary}K',
                      style: TextStyle(
                        color: kTitleBlack,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 3.h,
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.5.h),
                  child: Container(
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(
                        kCardRadius,
                      ),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      // give the indicator a decoration (color and border radius)
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          kCardRadius,
                        ),
                        color: const Color(0xFF88b4e1), //kAutismBridgeOrange,
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      tabs: const [
                        Tab(
                          text: 'Description',
                        ),
                        Tab(
                          text: 'Company',
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1.5.h),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 2.h,
                            ),
                            MyCardWidget(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 2.h, horizontal: 2.h),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 23,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            100.0), //or 15.0
                                        child: Container(
                                          height: double.infinity,
                                          width: double.infinity,
                                          color: kBackgroundRiceWhite,
                                          child: FittedBox(
                                            child: Image.file(
                                                recruiterProfile.profileImage!),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 3.w,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${recruiterProfile.firstName!} ${recruiterProfile.lastName!}',
                                          style: TextStyle(
                                            color: kTitleBlack,
                                            fontSize: 11.sp,
                                          ),
                                        ),
                                        Text(
                                          '${recruiterProfile.jobTitle!} · ${recruiterProfile.companyName!}',
                                          style: TextStyle(
                                            color: const Color(0xFF939393),
                                            fontSize: 11.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            MyCardWidget(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 2.h, horizontal: 2.h),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'About This Job Opportunity',
                                        style: TextStyle(
                                          color: kTitleBlack,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        recruiterJobPost.jobDescription!,
                                        style: TextStyle(
                                          color: const Color(0xFF939393),
                                          fontSize: 10.5.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            MyCardWidget(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 2.h, horizontal: 2.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Job Requirements',
                                        style: TextStyle(
                                          color: kTitleBlack,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Minimum Education: ',
                                              style: TextStyle(
                                                color: const Color(0xFF939393),
                                                fontSize: 10.sp,
                                              ),
                                            ),
                                            Text(
                                              'Minimum Experience: ',
                                              style: TextStyle(
                                                color: const Color(0xFF939393),
                                                fontSize: 10.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 0.5.w,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              recruiterJobPost.minEducation!,
                                              style: TextStyle(
                                                color: const Color(0xFF939393),
                                                fontSize: 10.sp,
                                              ),
                                            ),
                                            Text(
                                              recruiterJobPost.minExperience!,
                                              style: TextStyle(
                                                color: const Color(0xFF939393),
                                                fontSize: 10.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1.5.h),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 2.h,
                            ),
                            MyCardWidget(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 2.h, horizontal: 2.h),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'About This Company',
                                        style: TextStyle(
                                          color: kTitleBlack,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        recruiterCompanyInfo
                                            .companyDescription!,
                                        style: TextStyle(
                                          color: const Color(0xFF939393),
                                          fontSize: 10.5.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: kBackgroundRiceWhite,
          elevation: 0.0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.2.h),
            child: SizedBox(
              height: 6.25.h,
              child: MyBottomButton(
                onPressed: null,
                isHollow: false,
                child: Text(
                  'Apply',
                  style: TextStyle(
                    fontSize: 12.5.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
