import 'package:autism_bridge/models/job_display.dart';
import 'package:autism_bridge/models/recruiter_company_info.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

import '../color_constants.dart';
import '../num_constants.dart';
import 'my_card_widget.dart';

class JobRightTabView extends StatefulWidget {
  final JobDisplay jobDisplay;
  const JobRightTabView({
    Key? key,
    required this.jobDisplay,
  }) : super(key: key);

  @override
  _JobRightTabViewState createState() => _JobRightTabViewState();
}

class _JobRightTabViewState extends State<JobRightTabView>
    with AutomaticKeepAliveClientMixin {
  late final RecruiterCompanyInfo recruiterCompanyInfo;

  final Set<Marker> _companyAddressMarkers = {};

  void _onCompanyMapCreated(GoogleMapController controller) {
    setState(() {
      _companyAddressMarkers.add(
        Marker(
          markerId: const MarkerId('company-marker'),
          position: LatLng(
            recruiterCompanyInfo.lat!,
            recruiterCompanyInfo.lng!,
          ),
          infoWindow: InfoWindow(
            title: '${recruiterCompanyInfo.companyAddress}',
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    recruiterCompanyInfo = widget.jobDisplay.recruiterCompanyInfo;
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
                      recruiterCompanyInfo.companyDescription!,
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
            child: SizedBox(
              height: 23.h,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(kCardRadius),
                child: GoogleMap(
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      recruiterCompanyInfo.lat!,
                      recruiterCompanyInfo.lng!,
                    ),
                    zoom: 15,
                  ),
                  onMapCreated: _onCompanyMapCreated,
                  markers: _companyAddressMarkers,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 1.5.h,
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
