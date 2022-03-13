import 'package:autism_bridge/models/recruiter_job_post.dart';
import 'package:autism_bridge/models/recruiter_user_credentials.dart';
import 'package:autism_bridge/screens/recruiter_post_job_screen.dart';
import 'package:autism_bridge/widgets/my_card_widget.dart';
import 'package:autism_bridge/widgets/my_gradient_container.dart';
import 'package:autism_bridge/widgets/resume_builder_button.dart';
import 'package:autism_bridge/widgets/rounded_icon_container.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../constants.dart';

class RecruiterManagePostJobScreen extends StatefulWidget {
  static const id = 'recruiter_manage_job_post_screen';

  final RecruiterUserCredentials recruiterUserCredentials;

  final List<RecruiterJobPost?> recruiterJobPostList;

  const RecruiterManagePostJobScreen({
    Key? key,
    required this.recruiterUserCredentials,
    required this.recruiterJobPostList,
  }) : super(key: key);

  @override
  State<RecruiterManagePostJobScreen> createState() =>
      _RecruiterManagePostJobScreenState();
}

class _RecruiterManagePostJobScreenState
    extends State<RecruiterManagePostJobScreen> {
  List<RecruiterJobPost?>? recruiterJobPostList;
  Iterable<RecruiterJobPost?>? recruiterJobPostListReverse;

  Future<void> jobPostUpdateBtnOnPressed(
      {required String subCollectionId, required int listIndex}) async {
    final List<RecruiterJobPost?>? updatedRecruiterJobPostList =
        await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecruiterPostJobScreen(
          recruiterUserCredentials: widget.recruiterUserCredentials,
          isAddingNew: false,
          subCollectionId: subCollectionId,
          listIndex: listIndex,
          recruiterJobPostList: recruiterJobPostList!,
        ),
      ),
    );

    if (updatedRecruiterJobPostList != null) {
      recruiterJobPostList = updatedRecruiterJobPostList;
      setState(() {
        recruiterJobPostListReverse = updatedRecruiterJobPostList.reversed;
      });
    }
  }

  Future<void> jobPostAddNewBtnOnPressed() async {
    final List<RecruiterJobPost?>? updatedRecruiterJobPostList =
        await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecruiterPostJobScreen(
          recruiterUserCredentials: widget.recruiterUserCredentials,
          isAddingNew: true,
          recruiterJobPostList: recruiterJobPostList!,
        ),
      ),
    );

    if (updatedRecruiterJobPostList != null) {
      recruiterJobPostList = updatedRecruiterJobPostList;
      setState(() {
        recruiterJobPostListReverse = updatedRecruiterJobPostList.reversed;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    recruiterJobPostList = widget.recruiterJobPostList;
    recruiterJobPostListReverse = widget.recruiterJobPostList.reversed;
  }

  @override
  Widget build(BuildContext context) {
    final Widget segEdge = SizedBox(height: 1.h);
    return MyGradientContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          // title: const Text(
          //   'Job Preference',
          //   style: TextStyle(
          //     color: kTitleBlack,
          //   ),
          // ),
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
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: 1.h,
              vertical: 1.2.h,
            ),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 1.h),
                    child: Text(
                      'Manage My Jobs',
                      style: TextStyle(
                          color: kTitleBlack,
                          fontSize: 18.5.sp,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 1.h, right: 1.h, bottom: 1.h),
                    child: Text(
                      'Post your job,  get connection with ASD applicants',
                      style: TextStyle(
                        color: kRegistrationSubtitleGrey,
                        fontSize: 9.5.sp,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 0.8.h,
                  vertical: 0.9.h,
                ),
                child: MyCardWidget(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 1.5.h,
                      vertical: 1.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        recruiterJobPostList!.isNotEmpty
                            ? ListView.builder(
                                itemBuilder: (context, index) {
                                  final RecruiterJobPost? currentJobPost =
                                      recruiterJobPostListReverse!
                                          .elementAt(index);
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          jobPostUpdateBtnOnPressed(
                                            subCollectionId:
                                                currentJobPost!.subCollectionId,
                                            listIndex:
                                                recruiterJobPostList!.length -
                                                    index -
                                                    1,
                                          );
                                        },
                                        behavior: HitTestBehavior.translucent,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  currentJobPost!.jobName!,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: kTitleBlack,
                                                    fontSize: 11.5.sp,
                                                  ),
                                                ),
                                                Text(
                                                  currentJobPost
                                                          .maxSalary!.isEmpty
                                                      ? '${currentJobPost.minSalary}  •  ${currentJobPost.jobCity}  •  ${currentJobPost.employmentType}'
                                                      : '${currentJobPost.minSalary} - ${currentJobPost.maxSalary}  •  ${currentJobPost.jobCity}  •  ${currentJobPost.employmentType}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color:
                                                        kRegistrationSubtitleGrey,
                                                    fontSize: 9.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const IconButton(
                                              alignment: Alignment.centerRight,
                                              onPressed: null,
                                              icon: Icon(
                                                Icons.arrow_forward_ios,
                                                color:
                                                    kRegistrationSubtitleGrey,
                                                size: 20.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      index == recruiterJobPostList!.length - 1
                                          ? const SizedBox.shrink()
                                          : Divider(
                                              height: 2.8.h,
                                              thickness: 0.95,
                                              color: const Color(0xFFF0F0F2),
                                            ),
                                    ],
                                  );
                                },
                                itemCount: recruiterJobPostList!.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                              )
                            : Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        kResumeBuilderCardRadius),
                                    child: FittedBox(
                                      child: Image.asset(
                                          'images/undraw_post_job.png'),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Text(
                                    'Start post your first job ! ',
                                    style: TextStyle(
                                      color: kRegistrationSubtitleGrey,
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: kBackgroundRiceWhite,
          elevation: 0.0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.2.h),
            child: SizedBox(
              height: 6.25.h,
              child: ResumeBuilderButton(
                onPressed: jobPostAddNewBtnOnPressed,
                isHollow: false,
                child: Text(
                  'Post a job',
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
