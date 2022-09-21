import 'package:chat_app/constants/firestore_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ChatUser {
  final String id;
  final String photoUrl;
  final String displayName;
  final String phoneNumber;
  final String aboutMe;

  ChatUser({
    required this.id,
    required this.photoUrl,
    required this.displayName,
    required this.phoneNumber,
    required this.aboutMe,
  });

  Map<String, dynamic> toJson() => {
        FirestoreConstant.displayName: displayName,
        FirestoreConstant.photoUrl: photoUrl,
        FirestoreConstant.phoneNumber: phoneNumber,
        FirestoreConstant.aboutMe: aboutMe,
      };

  factory ChatUser.fromDocument(DocumentSnapshot snapshot) {
    String photoUrl = "";
    String nickname = "";
    String phoneNumber = "";
    String aboutMe = "";

    try {
      photoUrl = snapshot.get(FirestoreConstant.photoUrl);
      nickname = snapshot.get(FirestoreConstant.displayName);
      phoneNumber = snapshot.get(FirestoreConstant.phoneNumber);
      aboutMe = snapshot.get(FirestoreConstant.aboutMe);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return ChatUser(
      id: snapshot.id,
      photoUrl: photoUrl,
      displayName: nickname,
      phoneNumber: phoneNumber,
      aboutMe: aboutMe,
    );
  }
}
