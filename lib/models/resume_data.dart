import 'package:autism_bridge/models/autism_challenge_data.dart';
import 'package:autism_bridge/models/education_data.dart';
import 'package:autism_bridge/models/employment_history_data.dart';
import 'package:autism_bridge/models/personal_details_data.dart';
import 'package:autism_bridge/models/professional_summary_data.dart';
import 'package:autism_bridge/models/skill_data.dart';

class Resume {
  final PersonalDetails? userPersonalDetails;
  final ProfessionalSummary? userProfessionalSummary;
  final List<EmploymentHistory?> userEmploymentHistoryList;
  final List<Education?> userEducationList;
  final List<Skill?> userSkillList;
  final List<AutismChallenge?> userAutismChallengeList;

  Resume({
    required this.userPersonalDetails,
    required this.userProfessionalSummary,
    required this.userEmploymentHistoryList,
    required this.userEducationList,
    required this.userSkillList,
    required this.userAutismChallengeList,
  });
}
