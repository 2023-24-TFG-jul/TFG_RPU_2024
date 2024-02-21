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
    apiKey: 'AIzaSyDboo60c1ZF1hRQdza_ijl0A3ilLLjoLs0',
    appId: '1:1026884393861:web:e30892b467a5f7b748c2ec',
    messagingSenderId: '1026884393861',
    projectId: 'shiesty-ede35',
    authDomain: 'shiesty-ede35.firebaseapp.com',
    storageBucket: 'shiesty-ede35.appspot.com',
    measurementId: 'G-GKV9LY69VZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDu9PWzE_nSRnC1qfAIphNUwO0Qy-upuGY',
    appId: '1:1026884393861:android:d78236e351f43af648c2ec',
    messagingSenderId: '1026884393861',
    projectId: 'shiesty-ede35',
    storageBucket: 'shiesty-ede35.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAsrFgcvv4pXJR2qtfIB9ONz4v2NvTZpio',
    appId: '1:1026884393861:ios:c0a93b04bff4391f48c2ec',
    messagingSenderId: '1026884393861',
    projectId: 'shiesty-ede35',
    storageBucket: 'shiesty-ede35.appspot.com',
    iosBundleId: 'com.example.shiesty',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAsrFgcvv4pXJR2qtfIB9ONz4v2NvTZpio',
    appId: '1:1026884393861:ios:99806deba82ab85348c2ec',
    messagingSenderId: '1026884393861',
    projectId: 'shiesty-ede35',
    storageBucket: 'shiesty-ede35.appspot.com',
    iosBundleId: 'com.example.shiesty.RunnerTests',
  );
}
