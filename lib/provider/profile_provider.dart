import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider {
  final SharedPreferences sharedPreferences;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;

  ProfileProvider({
    required this.sharedPreferences,
    required this.firebaseFirestore,
    required this.firebaseStorage,
  });

  Future<bool> setPrefs(String key, String value) async {
    return await sharedPreferences.setString(key, value);
  }

  String? getPrefs(String key) {
    return sharedPreferences.getString(key);
  }

  UploadTask uploadImageFile(File image, String fileName) {
    Reference reference = firebaseStorage.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
  }

  Future<void> updateFirestoreData(String collectionPath, String path,
      Map<String, dynamic> dataUpatedNeeded) {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(path)
        .update(dataUpatedNeeded);
  }
}
