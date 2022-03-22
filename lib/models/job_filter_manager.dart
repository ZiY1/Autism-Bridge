import 'package:autism_bridge/models/job_display.dart';
import 'package:autism_bridge/models/job_preference_data.dart';
import 'package:autism_bridge/models/recruiter_company_info.dart';
import 'package:autism_bridge/models/recruiter_job_post.dart';
import 'package:autism_bridge/screens/recruiter_company_info_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JobFilterManager {
  static Future<List<JobDisplay>> filterJobFromFirestore(
      {required JobPreference jobSeekerJobPreference}) async {
    // TODO: modified where you store the min max salary to store integers rather than string

    // 1. Read the RecruiterJobPost by filtering with JobPreference
    // 2. For each RecruiterJobPost, fetch its corresponding RecruiterCompanyInfo
    //    if there is no key in the map, then store it in an map
    //    {key: docId, value: RecruiterCompanyInfo}.
    //    Otherwise, use the value of the key.
    // 3. Create a Job class containing RecruiterJobPost with its corresponding

    List<JobDisplay> filteredJobDisplayList = [];

    //TODO: create a map for recruiterCompanyInfo

    //TODO: implement the salary condition
    // If these two condition are not specific, no need to make them as a condition
    if (jobSeekerJobPreference.getEmploymentType == 'Any Type' &&
        jobSeekerJobPreference.getMinSalary == 'None') {
      FirebaseFirestore.instance
          .collection("all_jobs")
          .where('jobCategory',
              isEqualTo: jobSeekerJobPreference.getJobCategory)
          .where('jobTitle', isEqualTo: jobSeekerJobPreference.getJobTitle)
          .where('jobState', isEqualTo: jobSeekerJobPreference.getJobState)
          .where('jobCity', isEqualTo: jobSeekerJobPreference.getJobCity)
          .get()
          .then((querySnapshot) async {
        for (var singleJob in querySnapshot.docs) {
          print(singleJob.data()['jobName']);
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
              jobDescription: jobDescription);

          // Fetch the corresponding RecruiterCompanyInfo
          // TODO: add exception handling
          RecruiterCompanyInfo? recruiterCompanyInfoTemp =
              await RecruiterCompanyInfo.readRecruiterCompanyInfoFromFirestore(
                  userId);

          // Create a jobDisplay class
          JobDisplay jobDisplayTemp = JobDisplay(
              recruiterJobPost: recruiterJobPostTemp,
              recruiterCompanyInfo: recruiterCompanyInfoTemp!);

          // add the jobDisplay class to the list
          filteredJobDisplayList.add(jobDisplayTemp);
        }
      });
    }
    // If jobSeekerJobPreference.getEmploymentType is 'Any Type', no need to make it as a condition
    else if (jobSeekerJobPreference.getEmploymentType == 'Any Type') {
      FirebaseFirestore.instance
          .collection("all_jobs")
          .where('jobCategory',
              isEqualTo: jobSeekerJobPreference.getJobCategory)
          .where('jobTitle', isEqualTo: jobSeekerJobPreference.getJobTitle)
          .where('jobState', isEqualTo: jobSeekerJobPreference.getJobState)
          .where('jobCity', isEqualTo: jobSeekerJobPreference.getJobCity)
          .get()
          .then((querySnapshot) {
        for (var singleJob in querySnapshot.docs) {
          print(singleJob.data()['jobName']);
        }
      });
    }
    // If jobSeekerJobPreference.getMinSalary is 'Any Type', no need to make it as a condition
    else if (jobSeekerJobPreference.getMinSalary == 'None') {
      FirebaseFirestore.instance
          .collection("all_jobs")
          .where('employmentType',
              isEqualTo: jobSeekerJobPreference.getEmploymentType)
          .where('jobCategory',
              isEqualTo: jobSeekerJobPreference.getJobCategory)
          .where('jobTitle', isEqualTo: jobSeekerJobPreference.getJobTitle)
          .where('jobState', isEqualTo: jobSeekerJobPreference.getJobState)
          .where('jobCity', isEqualTo: jobSeekerJobPreference.getJobCity)
          .get()
          .then((querySnapshot) {
        for (var singleJob in querySnapshot.docs) {
          print(singleJob.data()['jobName']);
        }
      });
    }
    // Every preference is specific
    else {
      FirebaseFirestore.instance
          .collection("all_jobs")
          .where('employmentType',
              isEqualTo: jobSeekerJobPreference.getEmploymentType)
          .where('jobCategory',
              isEqualTo: jobSeekerJobPreference.getJobCategory)
          .where('jobTitle', isEqualTo: jobSeekerJobPreference.getJobTitle)
          .where('jobState', isEqualTo: jobSeekerJobPreference.getJobState)
          .where('jobCity', isEqualTo: jobSeekerJobPreference.getJobCity)
          .get()
          .then((querySnapshot) {
        for (var singleJob in querySnapshot.docs) {
          print(singleJob.data()['jobName']);
        }
      });
    }

    return filteredJobDisplayList;
  }
}
