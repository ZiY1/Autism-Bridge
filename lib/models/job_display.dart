import 'package:autism_bridge/models/recruiter_company_info.dart';
import 'package:autism_bridge/models/recruiter_job_post.dart';
import 'package:autism_bridge/models/recruiter_profile.dart';

class JobDisplay {
  final RecruiterProfile _recruiterProfile;
  final RecruiterJobPost _recruiterJobPost;
  final RecruiterCompanyInfo _recruiterCompanyInfo;

  JobDisplay({
    required RecruiterProfile recruiterProfile,
    required RecruiterJobPost recruiterJobPost,
    required RecruiterCompanyInfo recruiterCompanyInfo,
  })  : _recruiterProfile = recruiterProfile,
        _recruiterJobPost = recruiterJobPost,
        _recruiterCompanyInfo = recruiterCompanyInfo;

  // getters
  RecruiterProfile get recruiterProfile => _recruiterProfile;

  RecruiterJobPost get recruiterJobPost => _recruiterJobPost;

  RecruiterCompanyInfo get recruiterCompanyInfo => _recruiterCompanyInfo;
}
