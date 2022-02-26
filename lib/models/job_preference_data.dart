import 'package:cloud_firestore/cloud_firestore.dart';

class JobPreference {
  // TODO: figure out is this constructor with private members data structure better or the constructor final members in Resume Builder Data
  final String _userId;
  final String _subCollectionId;
  String _employmentType;
  String _jobCategory;
  String _jobTitle;
  String _jobCity;
  String _jobState;
  String _minSalary;
  String _maxSalary;

  JobPreference({
    required String userId,
    required String subCollectionId,
    required String employmentType,
    required String jobCategory,
    required String jobTitle,
    required String jobCity,
    required String jobState,
    required String minSalary,
    required String maxSalary,
  })  : _userId = userId,
        _subCollectionId = subCollectionId,
        _employmentType = employmentType,
        _jobCategory = jobCategory,
        _jobTitle = jobTitle,
        _jobCity = jobCity,
        _jobState = jobState,
        _minSalary = minSalary,
        _maxSalary = maxSalary;

  // This static method read all job preferences data (total 3) of a particular user from firestore
  static Future<List<JobPreference?>> readAllJobPreferenceDataFromFirestore(
      {required String userId}) async {
    List<JobPreference?> listJobPreferenceTemp = [];

    JobPreference? jobPreferenceTemp;

    Map<String, dynamic> data;

    String subCollectionId;
    String employmentType;
    String jobCategory;
    String jobTitle;
    String jobCity;
    String jobState;
    String minSalary;
    String maxSalary;

    try {
      await FirebaseFirestore.instance
          .collection('asd_job_preference')
          .doc(userId)
          .collection('job_preferences')
          .get()
          .then((querySnapshot) {
        for (var element in querySnapshot.docs) {
          data = element.data();

          subCollectionId = data['subCollectionId'];
          employmentType = data['employmentType'];
          jobCategory = data['jobCategory'];
          jobTitle = data['jobTitle'];
          jobCity = data['jobCity'];
          jobState = data['jobState'];
          minSalary = data['minSalary'];
          maxSalary = data['maxSalary'];

          jobPreferenceTemp = JobPreference(
            userId: userId,
            subCollectionId: subCollectionId,
            employmentType: employmentType,
            jobCategory: jobCategory,
            jobTitle: jobTitle,
            jobCity: jobCity,
            jobState: jobState,
            minSalary: minSalary,
            maxSalary: maxSalary,
          );

          listJobPreferenceTemp.add(jobPreferenceTemp);
        }
      });
    } on FirebaseException {
      rethrow;
    }

    return listJobPreferenceTemp;
  }

  // This static method delete a particular job preference data of a particular user to firestore
  static Future<void> deleteJobPreferenceToFirestore(
      {required String userId, required String mySubCollectionId}) async {
    try {
      await FirebaseFirestore.instance
          .collection('asd_job_preference')
          .doc(userId)
          .collection('job_preferences')
          .doc(mySubCollectionId)
          .delete();
    } on FirebaseException {
      rethrow;
    }
  }

  // This method add one a job preference data of a particular user to firestore
  Future<void> addJobPreferenceToFirestore() async {
    try {
      await FirebaseFirestore.instance
          .collection('asd_job_preference')
          .doc(_userId)
          .collection('job_preferences')
          .doc(_subCollectionId)
          .set({
        'subCollectionId': _subCollectionId,
        'employmentType': _employmentType,
        'jobCategory': _jobCategory,
        'jobTitle': _jobTitle,
        'jobCity': _jobCity,
        'jobState': _jobState,
        'minSalary': _minSalary,
        'maxSalary': _maxSalary,
      });
    } on FirebaseException {
      rethrow;
    }
  }

  // This method update a particular job preference data of a particular user to firestore
  Future<void> updateJobPreferenceToFirestore() async {
    try {
      await FirebaseFirestore.instance
          .collection('asd_job_preference')
          .doc(_userId)
          .collection('job_preferences')
          .doc(_subCollectionId)
          .update({
        'subCollectionId': _subCollectionId,
        'employmentType': _employmentType,
        'jobCategory': _jobCategory,
        'jobTitle': _jobTitle,
        'jobCity': _jobCity,
        'jobState': _jobState,
        'minSalary': _minSalary,
        'maxSalary': _maxSalary,
      });
    } on FirebaseException {
      rethrow;
    }
  }

  // Setters
  set setEmploymentType(String empType) => _employmentType = empType;

  set setJobCategory(String jobCategory) => _jobCategory = jobCategory;

  set setJobTitle(String jobTitle) => _jobTitle = jobTitle;

  set setJobCity(String jobCity) => _jobCity = jobCity;

  set setJobState(String jobState) => _jobState = jobState;

  set setMinSalary(String minSalary) => _minSalary = minSalary;

  set setMaxSalary(String maxSalary) => _maxSalary = maxSalary;

  // Getters
  String get getUserId => _userId;

  String get getSubCollectionId => _subCollectionId;

  String get getEmploymentType => _employmentType;

  String get getJobCategory => _jobCategory;

  String get getJobTitle => _jobTitle;

  String get getJobCity => _jobCity;

  String get getJobState => _jobState;

  String get getMinSalary => _minSalary;

  String get getMaxSalary => _maxSalary;
}
