import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Employer {
  // Attributes (the personal info of the Employer)
  String userId;
  String userUrlProfilePicture;
  String userFirstName;
  String userLastName;
  String userEmail;
  String userPassword;
  int userNewMessages;

  // constructor
  Employer({
    required this.userId,
    required this.userUrlProfilePicture,
    required this.userFirstName,
    required this.userLastName,
    required this.userEmail,
    required this.userPassword,
    required this.userNewMessages,
  });

  // Getters
  String get id {
    return userId;
  }

  String get urlProfilePicture {
    return userUrlProfilePicture;
  }

  String get firstName {
    return userFirstName;
  }

  String get lastName {
    return userLastName;
  }

  String get email {
    return userEmail;
  }

  String get password {
    return userPassword;
  }

  int get newMessages {
    return userNewMessages;
  }

  // Setters
  set urlProfilePicture(String newUrlProfilePicture) {
    userUrlProfilePicture = newUrlProfilePicture;
  }

  set firstName(String newFirstName) {
    userFirstName = newFirstName;
  }

  set lastName(String newLastName) {
    userLastName = newLastName;
  }

  set newMessage(int newNewMessage) {
    userNewMessages = newNewMessage;
  }

  set password(String newUserPassword) {
    userPassword = newUserPassword;
  }

  // Back End work

  // Change profile picture in the FireBase
  void changeUrlProfilePicture(File newProfilePictureFile) async {
    // Get access to the FirebaseStorage's folder 'user_images' and
    // map it to that user_Id
    final ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("user_images/")
        .child("${userId}.jpg");
    // Put that image file with the respective user Id
    await ref.putFile(newProfilePictureFile);

    // Get the url of the profile image of the user
    final userImageUrl = await ref.getDownloadURL();

    // Change the Profile picture in the Employer object
    urlProfilePicture = userImageUrl.toString();

    // update the info in the database
    FirebaseFirestore.instance.collection("EmployerUsers").doc(userId).update(
      {
        'urlProfileImage': userImageUrl.toString(),
      },
    );
  }
}
