import 'package:cloud_firestore/cloud_firestore.dart';

class Education {
  final String userId;
  final String subCollectionId;
  final String school;
  final String major;
  final String degree;
  final String startDate;
  final String endDate;
  final String state;
  final String city;
  final String description;

  Education({
    required this.userId,
    required this.subCollectionId,
    required this.school,
    required this.major,
    required this.degree,
    required this.startDate,
    required this.endDate,
    required this.state,
    required this.city,
    required this.description,
  });

  // This method tries to read all sub-collection employment_histories data from
  // the collection of cv_employment_history of current user.
  static Future<List<Education?>> readAllEducationDataFromFirestore(
      {required String userId}) async {
    List<Education?> listEducationTemp = [];

    Education? educationTemp;

    Map<String, dynamic> data;

    String subCollectionId;
    String school;
    String major;
    String degree;
    String startDate;
    String endDate;
    String state;
    String city;
    String description;

    await FirebaseFirestore.instance
        .collection('cv_education')
        .doc(userId)
        .collection('educations')
        .get()
        .then((querySnapshot) {
      // The loop will NOT be executed if there is no data
      for (var element in querySnapshot.docs) {
        data = element.data();

        subCollectionId = data['subCollectionId'];
        school = data['school'];
        major = data['major'];
        degree = data['degree'];
        startDate = data['startDate'];
        endDate = data['endDate'];
        state = data['state'];
        city = data['city'];
        description = data['description'];

        educationTemp = Education(
          userId: userId,
          subCollectionId: subCollectionId,
          school: school,
          major: major,
          degree: degree,
          startDate: startDate,
          endDate: endDate,
          state: state,
          city: city,
          description: description,
        );

        listEducationTemp.add(educationTemp);
      }
    });

    return listEducationTemp;
  }

  static Future<void> deleteEducationFromFirestore(
      {required String userId, required String mySubCollectionId}) async {
    await FirebaseFirestore.instance
        .collection('cv_education')
        .doc(userId)
        .collection('educations')
        .doc(mySubCollectionId)
        .delete();
  }

  Future<void> addEducationToFirestore() async {
    await FirebaseFirestore.instance
        .collection('cv_education')
        .doc(userId)
        .collection('educations')
        .doc(subCollectionId)
        .set({
      'subCollectionId': subCollectionId,
      'school': school,
      'major': major,
      'degree': degree,
      'startDate': startDate,
      'endDate': endDate,
      'state': state,
      'city': city,
      'description': description,
    });
  }

  Future<void> updateEducationToFirestore() async {
    await FirebaseFirestore.instance
        .collection('cv_education')
        .doc(userId)
        .collection('educations')
        .doc(subCollectionId)
        .update({
      'subCollectionId': subCollectionId,
      'school': school,
      'major': major,
      'degree': degree,
      'startDate': startDate,
      'endDate': endDate,
      'state': state,
      'city': city,
      'description': description,
    });
  }
}
