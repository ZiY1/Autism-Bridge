import 'package:cloud_firestore/cloud_firestore.dart';

class RecruiterJobPost {
  final String _userId;
  final String _subCollectionId;
  String? _jobName;
  String? _employmentType;
  String? _jobCategory;
  String? _jobTitle;
  String? _jobCity;
  String? _jobState;
  String? _jobAddress;
  String? _minExperience;
  String? _minEducation;
  double? _minSalary;
  double? _maxSalary;
  String? _jobDescription;
  double? _lat;
  double? _lng;

  RecruiterJobPost({
    required String userId,
    required String subCollectionId,
    required String? employmentType,
    required String? jobName,
    required String? jobCategory,
    required String? jobTitle,
    required String? jobCity,
    required String? jobState,
    required String? jobAddress,
    required String? minExperience,
    required String? minEducation,
    required double? minSalary,
    required double? maxSalary,
    required String? jobDescription,
    required double? lat,
    required double? lng,
  })  : _userId = userId,
        _subCollectionId = subCollectionId,
        _employmentType = employmentType,
        _jobName = jobName,
        _jobCategory = jobCategory,
        _jobTitle = jobTitle,
        _jobCity = jobCity,
        _jobState = jobState,
        _jobAddress = jobAddress,
        _minExperience = minExperience,
        _minEducation = minEducation,
        _minSalary = minSalary,
        _maxSalary = maxSalary,
        _jobDescription = jobDescription,
        _lat = lat,
        _lng = lng;

  // getters
  String get userId => _userId;

  String get subCollectionId => _subCollectionId;

  String? get employmentType => _employmentType;

  String? get jobName => _jobName;

  String? get jobCategory => _jobCategory;

  String? get jobTitle => _jobTitle;

  String? get jobCity => _jobCity;

  String? get jobState => _jobState;

  String? get jobAddress => _jobAddress;

  String? get minExperience => _minExperience;

  String? get minEducation => _minEducation;

  double? get minSalary => _minSalary;

  double? get maxSalary => _maxSalary;

  String? get jobDescription => _jobDescription;

  double? get lat => _lat;

  double? get lng => _lng;

  // setters
  set setEmploymentType(String? employmentType) =>
      _employmentType = employmentType;

  set setJobName(String? jobName) => _jobName = jobName;

  set setJobCategory(String? jobCategory) => _jobCategory = jobCategory;

  set setJobTitle(String? jobTitle) => _jobTitle = jobTitle;

  set setJobCity(String? jobCity) => _jobCity = jobCity;

  set setJobState(String? jobState) => _jobState = jobState;

  set setJobAddress(String? jobAddress) => _jobAddress = jobAddress;

  set setMinExperience(String? minExperience) => _minExperience = minExperience;

  set setMinEducation(String? minEducation) => _minEducation = minEducation;

  set setMinSalary(double? minSalary) => _minSalary = minSalary;

  set setMaxSalary(double? maxSalary) => _maxSalary = maxSalary;

  set setJobDescription(String? jobDescription) =>
      _jobDescription = jobDescription;

  set setLat(double? lat) => _lat = lat;

  set setLng(double? lng) => _lng = lng;

  static Future<List<RecruiterJobPost?>> readAllMyJobPostFromFirestore(
      {required String userId}) async {
    List<RecruiterJobPost?> listJobPostTemp = [];

    RecruiterJobPost? recruiterJobPostTemp;

    Map<String, dynamic> data;

    String subCollectionId;
    String employmentType;
    String jobName;
    String jobCategory;
    String jobTitle;
    String jobCity;
    String jobState;
    String jobAddress;
    String minExperience;
    String minEducation;
    double minSalary;
    double maxSalary;
    String jobDescription;
    double lat;
    double lng;

    try {
      await FirebaseFirestore.instance
          .collection('recruiter_job_post')
          .doc(userId)
          .collection('job_posts')
          .get()
          .then((querySnapshot) {
        for (var element in querySnapshot.docs) {
          data = element.data();

          subCollectionId = data['subCollectionId'];
          employmentType = data['employmentType'];
          jobName = data['jobName'];
          jobCategory = data['jobCategory'];
          jobTitle = data['jobTitle'];
          jobCity = data['jobCity'];
          jobState = data['jobState'];
          jobAddress = data['jobAddress'];
          minExperience = data['minExperience'];
          minEducation = data['minEducation'];
          minSalary = data['minSalary'];
          maxSalary = data['maxSalary'];
          jobDescription = data['jobDescription'];
          lat = data['lat'];
          lng = data['lng'];

          recruiterJobPostTemp = RecruiterJobPost(
            userId: userId,
            subCollectionId: subCollectionId,
            employmentType: employmentType,
            jobName: jobName,
            jobCategory: jobCategory,
            jobTitle: jobTitle,
            jobCity: jobCity,
            jobState: jobState,
            jobAddress: jobAddress,
            minExperience: minExperience,
            minEducation: minEducation,
            minSalary: minSalary,
            maxSalary: maxSalary,
            jobDescription: jobDescription,
            lat: lat,
            lng: lng,
          );

          listJobPostTemp.add(recruiterJobPostTemp);
        }
      });
    } on FirebaseException {
      rethrow;
    }

    return listJobPostTemp;
  }

  Future<void> addMyJobPostToRecruiterJobPostInFirestore() async {
    try {
      await FirebaseFirestore.instance
          .collection('recruiter_job_post')
          .doc(_userId)
          .collection('job_posts')
          .doc(_subCollectionId)
          .set({
        'subCollectionId': _subCollectionId,
        'employmentType': _employmentType,
        'jobName': _jobName,
        'jobCategory': _jobCategory,
        'jobTitle': _jobTitle,
        'jobCity': _jobCity,
        'jobState': _jobState,
        'jobAddress': _jobAddress,
        'minExperience': _minExperience,
        'minEducation': _minEducation,
        'minSalary': _minSalary,
        'maxSalary': _maxSalary,
        'jobDescription': _jobDescription,
        'lat': _lat,
        'lng': _lng,
      });
    } on FirebaseException {
      rethrow;
    }
  }

  Future<void> addMyJobPostToAllJobPostInFirestore() async {
    try {
      await FirebaseFirestore.instance
          .collection('all_jobs')
          .doc(_subCollectionId)
          .set({
        'collectionId': _userId,
        'subCollectionId': _subCollectionId,
        'employmentType': _employmentType,
        'jobName': _jobName,
        'jobCategory': _jobCategory,
        'jobTitle': _jobTitle,
        'jobCity': _jobCity,
        'jobState': _jobState,
        'jobAddress': _jobAddress,
        'minExperience': _minExperience,
        'minEducation': _minEducation,
        'minSalary': _minSalary,
        'maxSalary': _maxSalary,
        'jobDescription': _jobDescription,
        'lat': _lat,
        'lng': _lng,
      });
    } on FirebaseException {
      rethrow;
    }
  }

  Future<void> updateMyJobPostToRecruiterJobPostInFirestore() async {
    try {
      await FirebaseFirestore.instance
          .collection('recruiter_job_post')
          .doc(_userId)
          .collection('job_posts')
          .doc(_subCollectionId)
          .update({
        'subCollectionId': _subCollectionId,
        'employmentType': _employmentType,
        'jobName': _jobName,
        'jobCategory': _jobCategory,
        'jobTitle': _jobTitle,
        'jobCity': _jobCity,
        'jobState': _jobState,
        'jobAddress': _jobAddress,
        'minExperience': _minExperience,
        'minEducation': _minEducation,
        'minSalary': _minSalary,
        'maxSalary': _maxSalary,
        'jobDescription': _jobDescription,
        'lat': _lat,
        'lng': _lng,
      });
    } on FirebaseException {
      rethrow;
    }
  }

  Future<void> updateMyJobPostToAllJobPostInFirestore() async {
    try {
      await FirebaseFirestore.instance
          .collection('all_jobs')
          .doc(_subCollectionId)
          .update({
        'collectionId': _userId,
        'subCollectionId': _subCollectionId,
        'employmentType': _employmentType,
        'jobName': _jobName,
        'jobCategory': _jobCategory,
        'jobTitle': _jobTitle,
        'jobCity': _jobCity,
        'jobState': _jobState,
        'jobAddress': _jobAddress,
        'minExperience': _minExperience,
        'minEducation': _minEducation,
        'minSalary': _minSalary,
        'maxSalary': _maxSalary,
        'jobDescription': _jobDescription,
        'lat': _lat,
        'lng': _lng,
      });
    } on FirebaseException {
      rethrow;
    }
  }

  static Future<void> deleteMyJobPostInRecruiterJobPostInFirestore(
      {required String userId, required String mySubCollectionId}) async {
    try {
      await FirebaseFirestore.instance
          .collection('recruiter_job_post')
          .doc(userId)
          .collection('job_posts')
          .doc(mySubCollectionId)
          .delete();
    } on FirebaseException {
      rethrow;
    }
  }

  static Future<void> deleteMyJobPostToAllJobPostInFirestore(
      {required String subCollectionId}) async {
    try {
      await FirebaseFirestore.instance
          .collection('all_jobs')
          .doc(subCollectionId)
          .delete();
    } on FirebaseException {
      rethrow;
    }
  }
}
