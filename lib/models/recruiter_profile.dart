import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../regular_helpers.dart';

class RecruiterProfile {
  final String _userId;
  File? _profileImage;
  String? _profileImageUrl;
  String? _firstName;
  String? _lastName;
  String? _companyName;
  String? _jobTitle;

  RecruiterProfile({
    required String userId,
    required File? profileImage,
    required String? profileImageUrl,
    required String? firstName,
    required String? lastName,
    required String? companyName,
    required String? jobTitle,
  })  : _userId = userId,
        _profileImage = profileImage,
        _profileImageUrl = profileImageUrl,
        _firstName = firstName,
        _lastName = lastName,
        _companyName = companyName,
        _jobTitle = jobTitle;

  // getters
  String get userId => _userId;

  File? get profileImage => _profileImage;

  String? get profileImageUrl => _profileImageUrl;

  String? get firstName => _firstName;

  String? get lastName => _lastName;

  String? get companyName => _companyName;

  String? get jobTitle => _jobTitle;

  // setters
  set setProfileImage(File? profileImage) => _profileImage = profileImage;

  set setProfileImageUrl(String? profileImageUrl) =>
      _profileImageUrl = profileImageUrl;

  set setFirstName(String? firstName) => _firstName = firstName;

  set setLastName(String? lastName) => _lastName = lastName;

  set setCompanyName(String? companyName) => _companyName = companyName;

  set setJobTitle(String? jobTitle) => _jobTitle = jobTitle;

  static Future<void> createRecruiterProfileInFirestore(
      {required String userId}) async {
    await FirebaseFirestore.instance
        .collection('recruiter_profile')
        .doc(userId)
        .set({
      'profileImageUrl': '',
      'firstName': '',
      'lastName': '',
      'companyName': '',
      'jobTitle': '',
    });
  }

  // This method tries to read personal details data from firestore from 'userId',
  static Future<RecruiterProfile?> readRecruiterProfileDataFromFirestore(
      String userId) async {
    RecruiterProfile? recruiterProfile;
    await FirebaseFirestore.instance
        .collection('recruiter_profile')
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        final String profileImageUrl = data['profileImageUrl'];
        final String firstName = data['firstName'];
        final String lastName = data['lastName'];
        final String companyName = data['companyName'];
        final String jobTitle = data['jobTitle'];
        final File profileImage =
            await RegularHelpers.urlToFile(profileImageUrl);

        recruiterProfile = RecruiterProfile(
          userId: userId,
          profileImage: profileImage,
          profileImageUrl: profileImageUrl,
          firstName: firstName,
          lastName: lastName,
          companyName: companyName,
          jobTitle: jobTitle,
        );
      }
    });

    return recruiterProfile;
  }

  static Future<String> uploadProfileImageInStorage(
      {required String userId, required File profileImage}) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('recruiter_profile_image/')
        .child('$userId.jpg');

    await ref.putFile(profileImage);

    final userImageUrl = await ref.getDownloadURL();

    return userImageUrl;
  }

  Future<void> updateRecruiterProfileToFirestore() async {
    await FirebaseFirestore.instance
        .collection('recruiter_profile')
        .doc(_userId)
        .update({
      'profileImageUrl': _profileImageUrl,
      'firstName': _firstName,
      'lastName': _lastName,
      'companyName': _companyName,
      'jobTitle': _jobTitle,
    });
  }
}
