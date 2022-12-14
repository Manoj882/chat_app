// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBADfhmuazUn1XyXDEXNF769Ahl8Mac_ow',
    appId: '1:632601885814:web:6c90a8c382758202463357',
    messagingSenderId: '632601885814',
    projectId: 'chat-app-2ac28',
    authDomain: 'chat-app-2ac28.firebaseapp.com',
    storageBucket: 'chat-app-2ac28.appspot.com',
    measurementId: 'G-M6VJDL01Q4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD_QfhZfdiZVwh9cnH3tne6WQNzF2IMqQo',
    appId: '1:632601885814:android:9dff0c443eebdc56463357',
    messagingSenderId: '632601885814',
    projectId: 'chat-app-2ac28',
    storageBucket: 'chat-app-2ac28.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCivqJpiz0nBKK9zNUdjJlqR0JPR2cGlYg',
    appId: '1:632601885814:ios:1bef9992f121ae99463357',
    messagingSenderId: '632601885814',
    projectId: 'chat-app-2ac28',
    storageBucket: 'chat-app-2ac28.appspot.com',
    androidClientId: '632601885814-qcp5trj3k8ijcd33p6evddeo34r18fn6.apps.googleusercontent.com',
    iosClientId: '632601885814-fesgaiqsdhf3vomc1e3qdu5od05a2m0o.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCivqJpiz0nBKK9zNUdjJlqR0JPR2cGlYg',
    appId: '1:632601885814:ios:1bef9992f121ae99463357',
    messagingSenderId: '632601885814',
    projectId: 'chat-app-2ac28',
    storageBucket: 'chat-app-2ac28.appspot.com',
    androidClientId: '632601885814-qcp5trj3k8ijcd33p6evddeo34r18fn6.apps.googleusercontent.com',
    iosClientId: '632601885814-fesgaiqsdhf3vomc1e3qdu5od05a2m0o.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatApp',
  );
}
