import 'package:cloud_firestore/cloud_firestore.dart';

class EmploymentHistory {
  final String userId;
  final String subCollectionId;
  final String jobTitle;
  final String employer;
  final String employmentType;
  final String startDate;
  final String endDate;
  final String state;
  final String city;
  final String description;

  EmploymentHistory({
    required this.userId,
    required this.subCollectionId,
    required this.jobTitle,
    required this.employer,
    required this.employmentType,
    required this.startDate,
    required this.endDate,
    required this.city,
    required this.state,
    required this.description,
  });

  // This method tries to read all sub-collection employment_histories data from
  // the collection of cv_employment_history of current user.
  static Future<List<EmploymentHistory?>>
      readAllEmploymentHistoryDataFromFirestore(
          {required String userId}) async {
    List<EmploymentHistory?> listEmploymentHistoryTemp = [];

    EmploymentHistory? employmentHistoryTemp;

    Map<String, dynamic> data;

    String subCollectionId;
    String jobTitle;
    String employer;
    String employmentType;
    String startDate;
    String endDate;
    String state;
    String city;
    String description;

    await FirebaseFirestore.instance
        .collection('cv_employment_history')
        .doc(userId)
        .collection('employment_histories')
        .get()
        .then((querySnapshot) {
      for (var element in querySnapshot.docs) {
        data = element.data();

        subCollectionId = data['subCollectionId'];
        jobTitle = data['jobTitle'];
        employer = data['employer'];
        employmentType = data['employmentType'];
        startDate = data['startDate'];
        endDate = data['endDate'];
        state = data['state'];
        city = data['city'];
        description = data['description'];

        employmentHistoryTemp = EmploymentHistory(
          subCollectionId: subCollectionId,
          userId: userId,
          jobTitle: jobTitle,
          employer: employer,
          employmentType: employmentType,
          startDate: startDate,
          endDate: endDate,
          state: state,
          city: city,
          description: description,
        );

        listEmploymentHistoryTemp.add(employmentHistoryTemp);
      }
    });

    return listEmploymentHistoryTemp;
  }

  static Future<void> deleteEmploymentHistoryToFirestore(
      {required String userId, required String mySubCollectionId}) async {
    await FirebaseFirestore.instance
        .collection('cv_employment_history')
        .doc(userId)
        .collection('employment_histories')
        .doc(mySubCollectionId)
        .delete();
  }

  Future<void> addEmploymentHistoryToFirestore() async {
    await FirebaseFirestore.instance
        .collection('cv_employment_history')
        .doc(userId)
        .collection('employment_histories')
        .doc(subCollectionId)
        .set({
      'subCollectionId': subCollectionId,
      'jobTitle': jobTitle,
      'employer': employer,
      'employmentType': employmentType,
      'startDate': startDate,
      'endDate': endDate,
      'state': state,
      'city': city,
      'description': description,
    });
  }

  Future<void> updateEmploymentHistoryToFirestore() async {
    await FirebaseFirestore.instance
        .collection('cv_employment_history')
        .doc(userId)
        .collection('employment_histories')
        .doc(subCollectionId)
        .update({
      'subCollectionId': subCollectionId,
      'jobTitle': jobTitle,
      'employer': employer,
      'employmentType': employmentType,
      'startDate': startDate,
      'endDate': endDate,
      'state': state,
      'city': city,
      'description': description,
    });
  }
}
