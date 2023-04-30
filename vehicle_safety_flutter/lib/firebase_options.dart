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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAGgaTx60-oYH2pOHT5t_3TE009BLIYwqs',
    appId: '1:579594470706:web:1e052a8c553e30d3dac32b',
    messagingSenderId: '579594470706',
    projectId: 'accident-detection-c160e',
    authDomain: 'accident-detection-c160e.firebaseapp.com',
    databaseURL: 'https://accident-detection-c160e-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'accident-detection-c160e.appspot.com',
    measurementId: 'G-P8L2SYS6RL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBKqDP5iHu3ZCNKDjrZSUG-OlWEu104GgU',
    appId: '1:579594470706:android:03c3d6f0d3140f32dac32b',
    messagingSenderId: '579594470706',
    projectId: 'accident-detection-c160e',
    databaseURL: 'https://accident-detection-c160e-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'accident-detection-c160e.appspot.com',
  );
}
