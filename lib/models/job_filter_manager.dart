import 'package:autism_bridge/models/job_preference_data.dart';
import 'package:autism_bridge/models/recruiter_job_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JobFilterManager {
  static Future<List<Object?>> filterJobFromFirestore(
      {required JobPreference jobPreference}) async {
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('all_jobs');

    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    final List<Object?> list =
        querySnapshot.docs.map((doc) => doc.data()).toList();

    return list;
    // List<RecruiterJobPost?> listJobPostTemp = [];
    //
    // RecruiterJobPost? recruiterJobPostTemp;
    //
    // Map<String, dynamic> data;
    //
    // String subCollectionId;
    // String employmentType;
    // String jobName;
    // String jobCategory;
    // String jobTitle;
    // String jobCity;
    // String jobState;
    // String jobAddress;
    // String minExperience;
    // String minEducation;
    // String minSalary;
    // String maxSalary;
    // String jobDescription;
    //
    // try {
    //   await FirebaseFirestore.instance
    //       .collection('all_jobs')
    //       .doc(userId)
    //       .get()
    //       .then((querySnapshot) {
    //     for (var element in querySnapshot.docs) {
    //       data = element.data();
    //
    //       subCollectionId = data['subCollectionId'];
    //       employmentType = data['employmentType'];
    //       jobName = data['jobName'];
    //       jobCategory = data['jobCategory'];
    //       jobTitle = data['jobTitle'];
    //       jobCity = data['jobCity'];
    //       jobState = data['jobState'];
    //       jobAddress = data['jobAddress'];
    //       minExperience = data['minExperience'];
    //       minEducation = data['minEducation'];
    //       minSalary = data['minSalary'];
    //       maxSalary = data['maxSalary'];
    //       jobDescription = data['jobDescription'];
    //
    //       recruiterJobPostTemp = RecruiterJobPost(
    //         userId: userId,
    //         subCollectionId: subCollectionId,
    //         employmentType: employmentType,
    //         jobName: jobName,
    //         jobCategory: jobCategory,
    //         jobTitle: jobTitle,
    //         jobCity: jobCity,
    //         jobState: jobState,
    //         jobAddress: jobAddress,
    //         minExperience: minExperience,
    //         minEducation: minEducation,
    //         minSalary: minSalary,
    //         maxSalary: maxSalary,
    //         jobDescription: jobDescription,
    //       );
    //
    //       listJobPostTemp.add(recruiterJobPostTemp);
    //     }
    //   });
  }
}
//     } on FirebaseException {
//       rethrow;
//     }
//
//     return listJobPostTemp;
//   }
// }
