import 'package:chat_app/constants/firestore_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessages {
  String idFrom;
  String idTo;
  String timestamp;
  String content;
  int type;

  ChatMessages({
    required this.idFrom,
    required this.idTo,
    required this.timestamp,
    required this.content,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      FirestoreConstant.idFrom: idFrom,
      FirestoreConstant.idTo: idTo,
      FirestoreConstant.timestamp: timestamp,
      FirestoreConstant.content: content,
      FirestoreConstant.type: type,
    };
  }

  factory ChatMessages.fromDocument(DocumentSnapshot documentSnapshot) {
    String idFrom = documentSnapshot.get(FirestoreConstant.idFrom);
    String idTo = documentSnapshot.get(FirestoreConstant.idTo);
    String timestamp = documentSnapshot.get(FirestoreConstant.timestamp);
    String content = documentSnapshot.get(FirestoreConstant.content);
    int type = documentSnapshot.get(FirestoreConstant.type);

    return ChatMessages(
      idFrom: idFrom,
      idTo: idTo,
      timestamp: timestamp,
      content: content,
      type: type,
     );
  }
}
