import 'package:autism_bridge/models/autism_challenge_data.dart';
import 'package:autism_bridge/models/education_data.dart';
import 'package:autism_bridge/models/employment_history_data.dart';
import 'package:autism_bridge/models/personal_details_data.dart';
import 'package:autism_bridge/models/professional_summary_data.dart';
import 'package:autism_bridge/models/skill_data.dart';

class Resume {
  PersonalDetails? _userPersonalDetails;
  ProfessionalSummary? _userProfessionalSummary;
  List<EmploymentHistory?> _userEmploymentHistoryList;
  List<Education?> _userEducationList;
  List<Skill?> _userSkillList;
  List<AutismChallenge?> _userAutismChallengeList;

  Resume({
    required PersonalDetails? userPersonalDetails,
    required ProfessionalSummary? userProfessionalSummary,
    required List<EmploymentHistory?> userEmploymentHistoryList,
    required List<Education?> userEducationList,
    required List<Skill?> userSkillList,
    required List<AutismChallenge?> userAutismChallengeList,
  })  : _userPersonalDetails = userPersonalDetails,
        _userProfessionalSummary = userProfessionalSummary,
        _userEmploymentHistoryList = userEmploymentHistoryList,
        _userEducationList = userEducationList,
        _userSkillList = userSkillList,
        _userAutismChallengeList = userAutismChallengeList;

  PersonalDetails? get userPersonalDetails => _userPersonalDetails;

  ProfessionalSummary? get userProfessionalSummary => _userProfessionalSummary;

  List<EmploymentHistory?> get userEmploymentHistoryList =>
      _userEmploymentHistoryList;

  List<Education?> get userEducationList => _userEducationList;

  List<Skill?> get userSkillList => _userSkillList;

  List<AutismChallenge?> get userAutismChallengeList =>
      _userAutismChallengeList;

  set setPersonalDetails(PersonalDetails? personalDetails) =>
      _userPersonalDetails = personalDetails;

  set setProfessionalSummary(ProfessionalSummary? professionalSummary) =>
      _userProfessionalSummary = professionalSummary;

  set setEmploymentHistoryList(
          List<EmploymentHistory?> employmentHistoryList) =>
      _userEmploymentHistoryList = employmentHistoryList;

  set setEducationList(List<Education?> educationList) =>
      _userEducationList = educationList;

  set setSkillList(List<Skill?> skillList) => _userSkillList = skillList;

  set setAutismChallengeList(List<AutismChallenge?> autismChallengeList) =>
      _userAutismChallengeList = autismChallengeList;
}
