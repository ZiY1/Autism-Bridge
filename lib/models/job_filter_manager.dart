import 'package:autism_bridge/models/job_display.dart';
import 'package:autism_bridge/models/job_preference_data.dart';
import 'package:autism_bridge/models/recruiter_company_info.dart';
import 'package:autism_bridge/models/recruiter_job_post.dart';
import 'package:autism_bridge/models/recruiter_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../num_constants.dart';

class JobFilterManager {
  static Future<List<JobDisplay>> filterJobFromFirestore(
      {required List<JobPreference?> userJobPreferenceList,
      required int index}) async {
    // 1. Read the RecruiterJobPost by filtering with JobPreference
    // 2. For each RecruiterJobPost:
    //    2.1: fetch its corresponding RecruiterCompanyInfo
    //    if there is no key in the map, then store it in an map
    //    {key: docId, value: RecruiterCompanyInfo}.
    //    Otherwise, use the value of the key.
    //    2.2 fetch its corresponding RecruiterProfile
    // 3. Create a Job class containing RecruiterJobPost with its corresponding
    List<JobDisplay> filteredJobDisplayList = [];

    //TODO: maybe create a map for recruiterCompanyInfo?

    JobPreference userCurrentJobPreference = userJobPreferenceList[index]!;
    // If these two condition are not specific, no need to make them as a condition
    if (userCurrentJobPreference.getEmploymentType == 'Any Type' &&
        userCurrentJobPreference.getMinSalary == kNone) {
      await FirebaseFirestore.instance
          .collection("all_jobs")
          .where('jobCategory',
              isEqualTo: userCurrentJobPreference.getJobCategory)
          .where('jobTitle', isEqualTo: userCurrentJobPreference.getJobTitle)
          .where('jobState', isEqualTo: userCurrentJobPreference.getJobState)
          .where('jobCity', isEqualTo: userCurrentJobPreference.getJobCity)
          .get()
          .then((querySnapshot) async {
        filteredJobDisplayList = await jobFiltering(querySnapshot);
        return filteredJobDisplayList;
      });
    }
    // If jobSeekerJobPreference.getEmploymentType is 'Any Type', no need to make it as a condition
    else if (userCurrentJobPreference.getEmploymentType == 'Any Type') {
      if (userCurrentJobPreference.getMaxSalary == kEmpty) {
        await FirebaseFirestore.instance
            .collection("all_jobs")
            .where('jobCategory',
                isEqualTo: userCurrentJobPreference.getJobCategory)
            .where('jobTitle', isEqualTo: userCurrentJobPreference.getJobTitle)
            .where('jobState', isEqualTo: userCurrentJobPreference.getJobState)
            .where('jobCity', isEqualTo: userCurrentJobPreference.getJobCity)
            .where(
              'maxSalary',
              isEqualTo: userCurrentJobPreference.getMaxSalary,
            )
            .where(
              'minSalary',
              isEqualTo: userCurrentJobPreference.getMinSalary,
            )
            .get()
            .then((querySnapshot) async {
          filteredJobDisplayList = await jobFiltering(querySnapshot);
          return filteredJobDisplayList;
        });
      } else {
        await FirebaseFirestore.instance
            .collection("all_jobs")
            .where('jobCategory',
                isEqualTo: userCurrentJobPreference.getJobCategory)
            .where('jobTitle', isEqualTo: userCurrentJobPreference.getJobTitle)
            .where('jobState', isEqualTo: userCurrentJobPreference.getJobState)
            .where('jobCity', isEqualTo: userCurrentJobPreference.getJobCity)
            .where('minSalary',
                isGreaterThanOrEqualTo: userCurrentJobPreference.getMinSalary)
            .get()
            .then((querySnapshot) async {
          filteredJobDisplayList = await jobFiltering(querySnapshot);
          return filteredJobDisplayList;
        });
      }
    }
    // If jobSeekerJobPreference.getMinSalary is 'None', no need to make it as a condition
    else if (userCurrentJobPreference.getMinSalary == kNone) {
      await FirebaseFirestore.instance
          .collection("all_jobs")
          .where('employmentType',
              whereIn: [userCurrentJobPreference.getEmploymentType, 'Any Type'])
          .where('jobCategory',
              isEqualTo: userCurrentJobPreference.getJobCategory)
          .where('jobTitle', isEqualTo: userCurrentJobPreference.getJobTitle)
          .where('jobState', isEqualTo: userCurrentJobPreference.getJobState)
          .where('jobCity', isEqualTo: userCurrentJobPreference.getJobCity)
          .get()
          .then((querySnapshot) async {
            filteredJobDisplayList = await jobFiltering(querySnapshot);
            return filteredJobDisplayList;
          });
    }
    // Every preference is specific
    else {
      if (userCurrentJobPreference.getMaxSalary == kEmpty) {
        await FirebaseFirestore.instance
            .collection("all_jobs")
            .where('employmentType', whereIn: [
              userCurrentJobPreference.getEmploymentType,
              'Any Type'
            ])
            .where('jobCategory',
                isEqualTo: userCurrentJobPreference.getJobCategory)
            .where('jobTitle', isEqualTo: userCurrentJobPreference.getJobTitle)
            .where('jobState', isEqualTo: userCurrentJobPreference.getJobState)
            .where('jobCity', isEqualTo: userCurrentJobPreference.getJobCity)
            .where(
              'maxSalary',
              isEqualTo: userCurrentJobPreference.getMaxSalary,
            )
            .where(
              'minSalary',
              isEqualTo: userCurrentJobPreference.getMinSalary,
            )
            .get()
            .then((querySnapshot) async {
              filteredJobDisplayList = await jobFiltering(querySnapshot);
              return filteredJobDisplayList;
            });
      } else {
        await FirebaseFirestore.instance
            .collection("all_jobs")
            .where('employmentType', whereIn: [
              userCurrentJobPreference.getEmploymentType,
              'Any Type'
            ])
            .where('jobCategory',
                isEqualTo: userCurrentJobPreference.getJobCategory)
            .where('jobTitle', isEqualTo: userCurrentJobPreference.getJobTitle)
            .where('jobState', isEqualTo: userCurrentJobPreference.getJobState)
            .where('jobCity', isEqualTo: userCurrentJobPreference.getJobCity)
            .where('minSalary',
                isGreaterThanOrEqualTo: userCurrentJobPreference.getMinSalary)
            .get()
            .then((querySnapshot) async {
              filteredJobDisplayList = await jobFiltering(querySnapshot);
              return filteredJobDisplayList;
            });
      }
    }
    return filteredJobDisplayList;
  }

  static Future<List<JobDisplay>> jobFiltering(
      QuerySnapshot<Map<String, dynamic>> querySnapshot) async {
    List<JobDisplay> filteredJobListTemp = [];

    for (var singleJob in querySnapshot.docs) {
      var singleJobData = singleJob.data();

      // Read all fields
      String userId = singleJobData['collectionId'];
      String subCollectionId = singleJobData['subCollectionId'];
      String employmentType = singleJobData['employmentType'];
      String jobName = singleJobData['jobName'];
      String jobCategory = singleJobData['jobCategory'];
      String jobTitle = singleJobData['jobTitle'];
      String jobCity = singleJobData['jobCity'];
      String jobState = singleJobData['jobState'];
      String jobAddress = singleJobData['jobAddress'];
      String minExperience = singleJobData['minExperience'];
      String minEducation = singleJobData['minEducation'];
      double minSalary = singleJobData['minSalary'];
      double maxSalary = singleJobData['maxSalary'];
      String jobDescription = singleJobData['jobDescription'];
      double lat = singleJobData['lat'];
      double lng = singleJobData['lng'];

      // Create a RecruiterJobPost class
      RecruiterJobPost recruiterJobPostTemp = RecruiterJobPost(
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

      // 2.1 Fetch the corresponding RecruiterCompanyInfo
      // TODO: add exception handling
      RecruiterCompanyInfo? recruiterCompanyInfoTemp =
          await RecruiterCompanyInfo.readRecruiterCompanyInfoFromFirestore(
              userId);

      // TODO: add exception handling
      // 2.2 Fetch the corresponding RecruiterProfile
      RecruiterProfile? recruiterProfileTemp =
          await RecruiterProfile.readRecruiterProfileDataFromFirestore(userId);

      // Create a jobDisplay class
      JobDisplay jobDisplayTemp = JobDisplay(
          recruiterProfile: recruiterProfileTemp!,
          recruiterJobPost: recruiterJobPostTemp,
          recruiterCompanyInfo: recruiterCompanyInfoTemp!);

      // add the jobDisplay class to the list
      filteredJobListTemp.add(jobDisplayTemp);
    }
    // setState(() {
    //   filteredJobList = filteredJobListTemp;
    // });
    return filteredJobListTemp;
  }
}
