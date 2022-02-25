import 'dart:io';
import 'package:autism_bridge/regular_helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PersonalDetails {
  final String userId;
  final File profileImage;
  final String profileImageUrl;
  final String firstName;
  final String lastName;
  final String dateOfBirth;
  final String email;
  final String phone;
  final String state;
  final String city;
  final String address;
  final String postalCode;

  PersonalDetails({
    required this.userId,
    required this.profileImage,
    required this.profileImageUrl,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.email,
    required this.phone,
    required this.state,
    required this.city,
    required this.address,
    required this.postalCode,
  });

  static Future<void> createPersonalDetailsInFirestore(
      {required String userId}) async {
    await FirebaseFirestore.instance
        .collection('cv_personal_details')
        .doc(userId)
        .set({
      'profileImageUrl': '',
      'firstName': '',
      'lastName': '',
      'dateOfBirth': '',
      'email': '',
      'phone': '',
      'state': '',
      'city': '',
      'address': '',
      'postalCode': '',
    });
  }

  // This method tries to read personal details data from firestore from 'userId',
  static Future<PersonalDetails?> readPersonalDetailsDataFromFirestore(
      String userId) async {
    PersonalDetails? personalDetails;
    await FirebaseFirestore.instance
        .collection('cv_personal_details')
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        final String profileImageUrl = data['profileImageUrl'];
        final String firstName = data['firstName'];
        final String lastName = data['lastName'];
        final String dateOfBirth = data['dateOfBirth'];
        final String email = data['email'];
        final String phone = data['phone'];
        final String state = data['state'];
        final String city = data['city'];
        final String address = data['address'];
        final String postalCode = data['postalCode'];
        final File profileImage =
            await RegularHelpers.urlToFile(profileImageUrl);

        personalDetails = PersonalDetails(
          userId: userId,
          profileImage: profileImage,
          profileImageUrl: profileImageUrl,
          firstName: firstName,
          lastName: lastName,
          dateOfBirth: dateOfBirth,
          email: email,
          phone: phone,
          state: state,
          city: city,
          address: address,
          postalCode: postalCode,
        );
      }
    });

    return personalDetails;
  }

  static Future<String> uploadProfileImageInStorage(
      {required String userId, required File profileImage}) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('cv_user_profile_image/')
        .child('$userId.jpg');

    await ref.putFile(profileImage);

    final userImageUrl = await ref.getDownloadURL();

    return userImageUrl;
  }

  Future<void> updatePersonalDetailsToFirestore() async {
    await FirebaseFirestore.instance
        .collection('cv_personal_details')
        .doc(userId)
        .update({
      'profileImageUrl': profileImageUrl,
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth,
      'email': email,
      'phone': phone,
      'state': state,
      'city': city,
      'address': address,
      'postalCode': postalCode,
    });
  }
}
