import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../regular_helpers.dart';

class RecruiterCompanyInfo {
  final String _userId;
  File? _companyLogoImage;
  String? _companyLogoImageUrl;
  String? _companyName;
  String? _companyMinSize;
  String? _companyMaxSize;
  String? _companyAddress;
  String? _companyDescription;
  double? _lat;
  double? _lng;

  RecruiterCompanyInfo({
    required String userId,
    required File? companyLogoImage,
    required String? companyLogoImageUrl,
    required String? companyName,
    required String? companyMinSize,
    required String? companyMaxSize,
    required String? companyAddress,
    required String? companyDescription,
    required double? lat,
    required double? lng,
  })  : _userId = userId,
        _companyLogoImage = companyLogoImage,
        _companyLogoImageUrl = companyLogoImageUrl,
        _companyName = companyName,
        _companyMinSize = companyMinSize,
        _companyMaxSize = companyMaxSize,
        _companyAddress = companyAddress,
        _companyDescription = companyDescription,
        _lat = lat,
        _lng = lng;

  // getters
  String get userId => _userId;

  File? get companyLogoImage => _companyLogoImage;

  String? get companyLogoImageUrl => _companyLogoImageUrl;

  String? get companyName => _companyName;

  String? get companyMinSize => _companyMinSize;

  String? get companyMaxSize => _companyMaxSize;

  String? get companyAddress => _companyAddress;

  String? get companyDescription => _companyDescription;

  double? get lat => _lat;

  double? get lng => _lng;

  // setters
  set setCompanyLogoImage(File? companyLogoImage) =>
      _companyLogoImage = companyLogoImage;

  set setCompanyLogoImageUrl(String? companyLogoImageUrl) =>
      _companyLogoImageUrl = companyLogoImageUrl;

  set setCompanyName(String? companyName) => _companyName = companyName;

  set setCompanyMinSize(String? companyMinSize) =>
      _companyMinSize = companyMinSize;

  set setCompanyMaxSize(String? companyMaxSize) =>
      _companyMaxSize = companyMaxSize;

  set setCompanyAddress(String? companyAddress) =>
      _companyAddress = companyAddress;

  set setCompanyDescription(String? companyDescription) =>
      _companyDescription = companyDescription;

  set setLat(double? lat) => _lat = lat;

  set setLng(double? lng) => _lng = lng;

  static Future<void> createRecruiterCompanyInfoInFirestore(
      {required String userId}) async {
    try {
      await FirebaseFirestore.instance
          .collection('recruiter_company_info')
          .doc(userId)
          .set({
        'companyLogoImageUrl': '',
        'companyName': '',
        'companyMinSize': '',
        'companyMaxSize': '',
        'companyAddress': '',
        'companyDescription': '',
        'lat': 0.0,
        'lng': 0.0,
      });
    } on FirebaseException {
      rethrow;
    }
  }

  static Future<RecruiterCompanyInfo?> readRecruiterCompanyInfoFromFirestore(
      String userId) async {
    RecruiterCompanyInfo? recruiterCompanyInfo;
    try {
      await FirebaseFirestore.instance
          .collection('recruiter_company_info')
          .doc(userId)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;
          final String companyLogoImageUrl = data['companyLogoImageUrl'];
          final String companyName = data['companyName'];
          final String companyMinSize = data['companyMinSize'];
          final String companyMaxSize = data['companyMaxSize'];
          final String companyAddress = data['companyAddress'];
          final String companyDescription = data['companyDescription'];
          final double lat = data['lat'];
          final double lng = data['lng'];
          final File companyLogoImage =
              await RegularHelpers.urlToFile(companyLogoImageUrl);

          recruiterCompanyInfo = RecruiterCompanyInfo(
            userId: userId,
            companyLogoImage: companyLogoImage,
            companyLogoImageUrl: companyLogoImageUrl,
            companyName: companyName,
            companyMinSize: companyMinSize,
            companyMaxSize: companyMaxSize,
            companyAddress: companyAddress,
            companyDescription: companyDescription,
            lng: lng,
            lat: lat,
          );
        }
      });
    } on FirebaseException {
      rethrow;
    }

    return recruiterCompanyInfo;
  }

  static Future<String> uploadCompanyLogoImageInStorage(
      {required String userId, required File companyLogoImage}) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('recruiter_company_logo_image/')
        .child('$userId.jpg');

    // TODO: figure out how to handle exception here
    await ref.putFile(companyLogoImage);

    final userImageUrl = await ref.getDownloadURL();

    return userImageUrl;
  }

  Future<void> updateRecruiterCompanyInfoToFirestore() async {
    try {
      await FirebaseFirestore.instance
          .collection('recruiter_company_info')
          .doc(_userId)
          .update({
        'companyLogoImageUrl': _companyLogoImageUrl,
        'companyName': _companyName,
        'companyMinSize': _companyMinSize,
        'companyMaxSize': _companyMaxSize,
        'companyAddress': _companyAddress,
        'companyDescription': _companyDescription,
        'lat': _lat,
        'lng': _lng,
      });
    } on FirebaseException {
      rethrow;
    }
  }
}
