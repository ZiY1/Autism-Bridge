import 'package:cloud_firestore/cloud_firestore.dart';

class ProfessionalSummary {
  final String userId;
  final String summaryText;

  ProfessionalSummary({
    required this.userId,
    required this.summaryText,
  });

  static Future<void> createProfessionalSummaryInFirestore(
      {required String userId}) async {
    await FirebaseFirestore.instance
        .collection('cv_professional_summary')
        .doc(userId)
        .set({
      'summaryText': '',
    });
  }

  // This method tries to read professional summary data from firestore from 'userId'
  static Future<ProfessionalSummary?> readProfessionalSummaryDataFromFirestore(
      String userId) async {
    ProfessionalSummary? professionalSummary;
    await FirebaseFirestore.instance
        .collection('cv_professional_summary')
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        final String summaryText = data['summaryText'];

        professionalSummary = ProfessionalSummary(
          userId: userId,
          summaryText: summaryText,
        );
      }
    });

    return professionalSummary;
  }

  Future<void> updateProfessionalSummaryToFirestore() async {
    await FirebaseFirestore.instance
        .collection('cv_professional_summary')
        .doc(userId)
        .update({
      'summaryText': summaryText,
    });
  }
}
