import 'package:cloud_firestore/cloud_firestore.dart';

class AutismChallenge {
  final String userId;
  final String subCollectionId;
  final String challengeName;
  final String challengeLevel;
  final String challengeDescription;

  AutismChallenge({
    required this.userId,
    required this.subCollectionId,
    required this.challengeName,
    required this.challengeLevel,
    required this.challengeDescription,
  });

  static Future<List<AutismChallenge?>> readAllAutismChallengeDataFromFirestore(
      {required String userId}) async {
    List<AutismChallenge?> listAutismChallengeTemp = [];

    AutismChallenge? autismChallengeTemp;

    Map<String, dynamic> data;

    String subCollectionId;
    String challengeName;
    String challengeLevel;
    String challengeDescription;

    await FirebaseFirestore.instance
        .collection('cv_autism_challenge')
        .doc(userId)
        .collection('autism_challenges')
        .get()
        .then((querySnapshot) {
      // The loop will NOT be executed if there is no data
      for (var element in querySnapshot.docs) {
        data = element.data();

        subCollectionId = data['subCollectionId'];
        challengeName = data['challengeName'];
        challengeLevel = data['challengeLevel'];
        challengeDescription = data['challengeDescription'];

        autismChallengeTemp = AutismChallenge(
          userId: userId,
          subCollectionId: subCollectionId,
          challengeName: challengeName,
          challengeLevel: challengeLevel,
          challengeDescription: challengeDescription,
        );

        listAutismChallengeTemp.add(autismChallengeTemp);
      }
    });

    return listAutismChallengeTemp;
  }

  static Future<void> deleteAutismChallengeFromFirestore(
      {required String userId, required String mySubCollectionId}) async {
    await FirebaseFirestore.instance
        .collection('cv_autism_challenge')
        .doc(userId)
        .collection('autism_challenges')
        .doc(mySubCollectionId)
        .delete();
  }

  Future<void> addAutismChallengeToFirestore() async {
    await FirebaseFirestore.instance
        .collection('cv_autism_challenge')
        .doc(userId)
        .collection('autism_challenges')
        .doc(subCollectionId)
        .set({
      'subCollectionId': subCollectionId,
      'challengeName': challengeName,
      'challengeLevel': challengeLevel,
      'challengeDescription': challengeDescription,
    });
  }

  Future<void> updateAutismChallengeToFirestore() async {
    await FirebaseFirestore.instance
        .collection('cv_autism_challenge')
        .doc(userId)
        .collection('autism_challenges')
        .doc(subCollectionId)
        .update({
      'subCollectionId': subCollectionId,
      'challengeName': challengeName,
      'challengeLevel': challengeLevel,
      'challengeDescription': challengeDescription,
    });
  }
}
