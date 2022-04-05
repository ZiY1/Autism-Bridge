import 'package:autism_bridge/models/job_display.dart';
import 'package:autism_bridge/models/recruiter_job_post.dart';
import 'package:autism_bridge/models/recruiter_profile.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

import '../color_constants.dart';
import '../num_constants.dart';
import 'my_card_widget.dart';

class JobLeftTabView extends StatefulWidget {
  final JobDisplay jobDisplay;
  const JobLeftTabView({
    Key? key,
    required this.jobDisplay,
  }) : super(key: key);

  @override
  _JobLeftTabViewState createState() => _JobLeftTabViewState();
}

class _JobLeftTabViewState extends State<JobLeftTabView>
    with AutomaticKeepAliveClientMixin {
  late final RecruiterProfile recruiterProfile;

  late final RecruiterJobPost recruiterJobPost;

  final Set<Marker> _jobAddressMarkers = {};

  void _onJobMapCreated(GoogleMapController controller) {
    //_googleMapJobController = controller;
    setState(() {
      _jobAddressMarkers.add(
        Marker(
          markerId: const MarkerId('job-marker'),
          position: LatLng(
            recruiterJobPost.lat!,
            recruiterJobPost.lng!,
          ),
          infoWindow: InfoWindow(
            title: '${recruiterJobPost.jobAddress}',
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    recruiterProfile = widget.jobDisplay.recruiterProfile;
    recruiterJobPost = widget.jobDisplay.recruiterJobPost;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.5.h),
      child: Column(
        children: [
          SizedBox(
            height: 2.h,
          ),
          MyCardWidget(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.h),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 23,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100.0), //or 15.0
                      child: Container(
                        height: double.infinity,
                        width: double.infinity,
                        color: kBackgroundRiceWhite,
                        child: FittedBox(
                          child: Image.file(recruiterProfile.profileImage!),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 3.w,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.h),
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
              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.h),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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
          SizedBox(
            height: 1.5.h,
          ),
          MyCardWidget(
            child: SizedBox(
              height: 23.h,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(kCardRadius),
                child: GoogleMap(
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      widget.jobDisplay.recruiterJobPost.lat!,
                      widget.jobDisplay.recruiterJobPost.lng!,
                    ),
                    zoom: 15,
                  ),
                  onMapCreated: _onJobMapCreated,
                  markers: _jobAddressMarkers,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
