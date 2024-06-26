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
    apiKey: 'AIzaSyCl1Y-lswFdWr5T7G4XoR0KETKJtjrbUws',
    appId: '1:969707894614:web:a9fe6a4119075ee13248f7',
    messagingSenderId: '969707894614',
    projectId: 'bajaapp-df4b1',
    authDomain: 'bajaapp-df4b1.firebaseapp.com',
    storageBucket: 'bajaapp-df4b1.appspot.com',
    measurementId: 'G-L085SSQJ38',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBTegVBoA_fncPSpjqPm8g4xLp3WbqNrJs',
    appId: '1:969707894614:android:9035ea2044cf11063248f7',
    messagingSenderId: '969707894614',
    projectId: 'bajaapp-df4b1',
    storageBucket: 'bajaapp-df4b1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDFzS6Ivcu34dG2cLwF19FKqLkJWRqZfbM',
    appId: '1:969707894614:ios:90e9262390ea78353248f7',
    messagingSenderId: '969707894614',
    projectId: 'bajaapp-df4b1',
    storageBucket: 'bajaapp-df4b1.appspot.com',
    iosBundleId: 'com.example.bajaApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDFzS6Ivcu34dG2cLwF19FKqLkJWRqZfbM',
    appId: '1:969707894614:ios:90e9262390ea78353248f7',
    messagingSenderId: '969707894614',
    projectId: 'bajaapp-df4b1',
    storageBucket: 'bajaapp-df4b1.appspot.com',
    iosBundleId: 'com.example.bajaApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCl1Y-lswFdWr5T7G4XoR0KETKJtjrbUws',
    appId: '1:969707894614:web:c53f3b7fb831ed583248f7',
    messagingSenderId: '969707894614',
    projectId: 'bajaapp-df4b1',
    authDomain: 'bajaapp-df4b1.firebaseapp.com',
    storageBucket: 'bajaapp-df4b1.appspot.com',
    measurementId: 'G-RZ0EZ0Z5P5',
  );
}
