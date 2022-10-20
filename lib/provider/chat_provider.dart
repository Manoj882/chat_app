import 'dart:io';

import 'package:chat_app/constants/firestore_constant.dart';
import 'package:chat_app/models/chat_messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatProvider {
  final SharedPreferences sharedPreferences;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;

  ChatProvider({
    required this.sharedPreferences,
    required this.firebaseFirestore,
    required this.firebaseStorage,
  });

  UploadTask uploadImageFile(File image, String fileName) {
    final reference = firebaseStorage.ref().child(fileName);
    final uploadTask = reference.putFile(image);
    return uploadTask;
  }

  Future<void> updateFirestoreData(
      String collectionPath, String docPath, Map<String, dynamic> dataUpdate) {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(docPath)
        .update(dataUpdate);
  }

  Stream<QuerySnapshot> getChatMessage(String groupChatId, int limit) {
    return firebaseFirestore
        .collection(FirestoreConstant.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy(FirestoreConstant.timestamp, descending: true)
        .limit(limit)
        .snapshots();
  }

  void sendChatMessage(String content, int type, String groupChatId,
      String currentUserId, String peerId) {
    final documentReference = firebaseFirestore
        .collection(FirestoreConstant.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    ChatMessages chatMessages = ChatMessages(
      idFrom: currentUserId,
      idTo: peerId,
      timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      type: type,
    );

    FirebaseFirestore.instance.runTransaction((transaction) async{
      transaction.set(documentReference, chatMessages.toJson());

    });
  }

  
}

class MessageType{
  static const text = 0;
  static const image = 1;
  static const sticker = 2;
    
  }
