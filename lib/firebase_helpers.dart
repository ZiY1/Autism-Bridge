import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {
  // Check if a document exists
  static Future<bool> checkDocumentExists(
      {required String collectionName, required String docID}) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance
            .collection(collectionName)
            .doc(docID)
            .get();
    if (documentSnapshot.exists) {
      return true;
    } else {
      return false;
    }
  }
}
