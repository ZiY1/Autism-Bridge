import 'package:cloud_firestore/cloud_firestore.dart';

class Skill {
  final String userId;
  final String subCollectionId;
  final String skillName;
  final String skillLevel;
  final String skillDescription;

  Skill({
    required this.userId,
    required this.subCollectionId,
    required this.skillName,
    required this.skillLevel,
    required this.skillDescription,
  });

  static Future<List<Skill?>> readAllSkillDataFromFirestore(
      {required String userId}) async {
    List<Skill?> listSkillTemp = [];

    Skill? skillTemp;

    Map<String, dynamic> data;

    String subCollectionId;
    String skillName;
    String skillLevel;
    String skillDescription;

    await FirebaseFirestore.instance
        .collection('cv_skill')
        .doc(userId)
        .collection('skills')
        .get()
        .then((querySnapshot) {
      // The loop will NOT be executed if there is no data
      for (var element in querySnapshot.docs) {
        data = element.data();

        subCollectionId = data['subCollectionId'];
        skillName = data['skillName'];
        skillLevel = data['skillLevel'];
        skillDescription = data['skillDescription'];

        skillTemp = Skill(
          userId: userId,
          subCollectionId: subCollectionId,
          skillName: skillName,
          skillLevel: skillLevel,
          skillDescription: skillDescription,
        );

        listSkillTemp.add(skillTemp);
      }
    });

    return listSkillTemp;
  }

  static Future<void> deleteSkillFromFirestore(
      {required String userId, required String mySubCollectionId}) async {
    await FirebaseFirestore.instance
        .collection('cv_skill')
        .doc(userId)
        .collection('skills')
        .doc(mySubCollectionId)
        .delete();
  }

  Future<void> addSkillToFirestore() async {
    await FirebaseFirestore.instance
        .collection('cv_skill')
        .doc(userId)
        .collection('skills')
        .doc(subCollectionId)
        .set({
      'subCollectionId': subCollectionId,
      'skillName' : skillName,
      'skillLevel' : skillLevel,
      'skillDescription' : skillDescription,
    });
  }

  Future<void> updateSkillToFirestore() async {
    await FirebaseFirestore.instance
        .collection('cv_skill')
        .doc(userId)
        .collection('skills')
        .doc(subCollectionId)
        .update({
      'subCollectionId': subCollectionId,
      'skillName' : skillName,
      'skillLevel' : skillLevel,
      'skillDescription' : skillDescription,
    });
  }
}
