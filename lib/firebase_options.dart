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
    apiKey: 'AIzaSyBqA9TloSEABLglGsv4bmhZN_lmqMAcZ5U',
    appId: '1:763342555393:web:67a8a8a6bd93ce4ff0f300',
    messagingSenderId: '763342555393',
    projectId: 'diaryapp-b504e',
    authDomain: 'diaryapp-b504e.firebaseapp.com',
    storageBucket: 'diaryapp-b504e.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDfphK6x0N2hG3dyH37xcHVnrupLS4K3Jo',
    appId: '1:763342555393:android:8c6fbeb4a74b0ee1f0f300',
    messagingSenderId: '763342555393',
    projectId: 'diaryapp-b504e',
    storageBucket: 'diaryapp-b504e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCLoXu-ONrbWeYNAwv1_gAFMBeUZSGbPp0',
    appId: '1:763342555393:ios:f978c2da0047ff66f0f300',
    messagingSenderId: '763342555393',
    projectId: 'diaryapp-b504e',
    storageBucket: 'diaryapp-b504e.appspot.com',
    iosBundleId: 'com.example.dearDiary',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCLoXu-ONrbWeYNAwv1_gAFMBeUZSGbPp0',
    appId: '1:763342555393:ios:6a6b884e31d758e8f0f300',
    messagingSenderId: '763342555393',
    projectId: 'diaryapp-b504e',
    storageBucket: 'diaryapp-b504e.appspot.com',
    iosBundleId: 'com.example.dearDiary.RunnerTests',
  );
}
