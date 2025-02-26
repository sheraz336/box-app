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
    apiKey: 'AIzaSyBdVrJ7f-hrwrYiHEd9ueYRbJI87aHtx_M',
    appId: '1:984496861173:web:7a7ae217276c5213887abc',
    messagingSenderId: '984496861173',
    projectId: 'finditorium',
    authDomain: 'finditorium.firebaseapp.com',
    storageBucket: 'finditorium.firebasestorage.app',
    measurementId: 'G-SZSZGF6RVE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBNaqo_208XIWDWVLR3f9TMWSJS76TYoJQ',
    appId: '1:984496861173:android:685d09cc09bdaf1d887abc',
    messagingSenderId: '984496861173',
    projectId: 'finditorium',
    storageBucket: 'finditorium.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDnDrFXdam8kul3agbUZneVT1k65WH1Dzk',
    appId: '1:984496861173:ios:cee688b380907650887abc',
    messagingSenderId: '984496861173',
    projectId: 'finditorium',
    storageBucket: 'finditorium.firebasestorage.app',
    androidClientId: '984496861173-0g7up0aqmq1t9uv2eb33d0cvcnbutqi1.apps.googleusercontent.com',
    iosClientId: '984496861173-jq1q7flj8gt3tro3khn9kmunns63j39k.apps.googleusercontent.com',
    iosBundleId: 'com.app.finditorium',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDnDrFXdam8kul3agbUZneVT1k65WH1Dzk',
    appId: '1:984496861173:ios:b06fa62a6b77ce9b887abc',
    messagingSenderId: '984496861173',
    projectId: 'finditorium',
    storageBucket: 'finditorium.firebasestorage.app',
    androidClientId: '984496861173-0g7up0aqmq1t9uv2eb33d0cvcnbutqi1.apps.googleusercontent.com',
    iosClientId: '984496861173-efumegel2t846o08gk3soa27rhs8k2ku.apps.googleusercontent.com',
    iosBundleId: 'com.example.boxDeliveryApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBdVrJ7f-hrwrYiHEd9ueYRbJI87aHtx_M',
    appId: '1:984496861173:web:49db1182ff5ea7bb887abc',
    messagingSenderId: '984496861173',
    projectId: 'finditorium',
    authDomain: 'finditorium.firebaseapp.com',
    storageBucket: 'finditorium.firebasestorage.app',
    measurementId: 'G-2G8CYWPFQ5',
  );

}