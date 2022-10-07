
import 'package:chat_app/constants/firestore_constant.dart';
import 'package:chat_app/models/chat_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Status{
  uninitialized,
  authenticated,
  authenticating,
  authenticateError,
  authenticateCanceled,
}

class AuthProvider extends ChangeNotifier{
  final GoogleSignIn googleSignIn;
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final SharedPreferences sharedPreferences;

  Status _status = Status.uninitialized;
  Status get status => _status;

  AuthProvider({
    required this.googleSignIn,
    required this.firebaseAuth,
    required this.firebaseFirestore,
    required this.sharedPreferences,
  });
  
  String? getFirebaseUserId(){
    return sharedPreferences.getString(FirestoreConstant.id);
  }

  Future<bool> isLoggedIn() async{
    bool isLoggedIn = await googleSignIn.isSignedIn();
    if(isLoggedIn && sharedPreferences.getString(FirestoreConstant.id)?.isNotEmpty == true){
      return true;
    } else{
      return false;
    }
  }

  Future<bool> handleGoogleSignIn() async{
    _status = Status.authenticating;
    notifyListeners();

    final googleUser = await googleSignIn.signIn();
    if(googleUser != null){
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final firebaseUser = (await firebaseAuth.signInWithCredential(credential)).user;

      if(firebaseUser != null){
        final result = await firebaseFirestore.collection(FirestoreConstant.pathUserCollection).where(FirestoreConstant.id, isEqualTo: firebaseUser.uid).get();
        final document = result.docs;

        if(document.isEmpty){
          firebaseFirestore.collection(FirestoreConstant.pathUserCollection).doc(firebaseUser.uid).set({
            FirestoreConstant.displayName: firebaseUser.displayName,
            FirestoreConstant.photoUrl: firebaseUser.photoURL,
            FirestoreConstant.id: firebaseUser.uid,
            'createAt': DateTime.now().microsecondsSinceEpoch.toString(),
            FirestoreConstant.chattingWith: null,
          });

          final currentUser = firebaseUser;
          await sharedPreferences.setString(FirestoreConstant.id, currentUser.uid);
          await sharedPreferences.setString(FirestoreConstant.displayName, currentUser.displayName ?? '');
          await sharedPreferences.setString(FirestoreConstant.photoUrl, currentUser.photoURL ?? '');
          await sharedPreferences.setString(FirestoreConstant.phoneNumber, currentUser.phoneNumber ?? '');

        } else{
          final documentSnapshot = document[0];
          final chatUser = ChatUser.fromDocument(documentSnapshot);
          await sharedPreferences.setString(FirestoreConstant.id, chatUser.id);
          await sharedPreferences.setString(FirestoreConstant.displayName, chatUser.displayName);
          await sharedPreferences.setString(FirestoreConstant.phoneNumber, chatUser.phoneNumber);
          await sharedPreferences.setString(FirestoreConstant.aboutMe, chatUser.aboutMe);
          
        }
        _status = Status.authenticated;
        notifyListeners();
        return true;
      } else {
        _status = Status.authenticateError;
        notifyListeners();
        return false;
      }
    } else {
      _status = Status.authenticateCanceled;
      notifyListeners();
      return false;
    }

   

  }
  Future<void> googleSignOut() async{
    _status = Status.uninitialized;
    await firebaseAuth.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
  }
}