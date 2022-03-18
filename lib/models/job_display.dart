import 'package:autism_bridge/models/recruiter_company_info.dart';
import 'package:autism_bridge/models/recruiter_job_post.dart';

class JobDisplay {
  final RecruiterJobPost _recruiterJobPost;
  final RecruiterCompanyInfo _recruiterCompanyInfo;

  JobDisplay({
    required RecruiterJobPost recruiterJobPost,
    required RecruiterCompanyInfo recruiterCompanyInfo,
  })  : _recruiterJobPost = recruiterJobPost,
        _recruiterCompanyInfo = recruiterCompanyInfo;

  // getters

  RecruiterJobPost get recruiterJobPost => _recruiterJobPost;

  RecruiterCompanyInfo get recruiterCompanyInfo => _recruiterCompanyInfo;
}
