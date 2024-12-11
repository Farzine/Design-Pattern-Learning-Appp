// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyB_bkJeXIv3LHnl0QCzNJp2glI4Mgcxh5A',
    appId: '1:1035139937771:web:fb08ae87fd797b108495ae',
    messagingSenderId: '1035139937771',
    projectId: 'dpla-13763',
    authDomain: 'dpla-13763.firebaseapp.com',
    storageBucket: 'dpla-13763.firebasestorage.app',
    measurementId: 'G-04JCMJC5H8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCI2IuPzsjA4g-nIOtmYuxW8u_qg4qkX38',
    appId: '1:1035139937771:android:aac9de643c2c16f08495ae',
    messagingSenderId: '1035139937771',
    projectId: 'dpla-13763',
    storageBucket: 'dpla-13763.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAoGvX88vAEikhNyf-HTcX5LG9mLFdWvBM',
    appId: '1:1035139937771:ios:d24547a1fd0f37088495ae',
    messagingSenderId: '1035139937771',
    projectId: 'dpla-13763',
    storageBucket: 'dpla-13763.firebasestorage.app',
    iosBundleId: 'com.example.frontend',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAoGvX88vAEikhNyf-HTcX5LG9mLFdWvBM',
    appId: '1:1035139937771:ios:d24547a1fd0f37088495ae',
    messagingSenderId: '1035139937771',
    projectId: 'dpla-13763',
    storageBucket: 'dpla-13763.firebasestorage.app',
    iosBundleId: 'com.example.frontend',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB_bkJeXIv3LHnl0QCzNJp2glI4Mgcxh5A',
    appId: '1:1035139937771:web:25a8328d1f1759a18495ae',
    messagingSenderId: '1035139937771',
    projectId: 'dpla-13763',
    authDomain: 'dpla-13763.firebaseapp.com',
    storageBucket: 'dpla-13763.firebasestorage.app',
    measurementId: 'G-0H7RXD5VKQ',
  );
}
