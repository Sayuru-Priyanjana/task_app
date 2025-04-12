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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD6SRD62xaa3SlGfntqa7WWukITAKPICic',
    appId: '1:547028898766:android:7a320fb79d11758d98519f',
    messagingSenderId: '547028898766',
    projectId: 'task-app-85e6d',
    databaseURL: 'https://task-app-85e6d-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'task-app-85e6d.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA8dRI5mRo0plszxkouS1JxKQ2FKTQbmt0',
    appId: '1:547028898766:ios:22995868fe42252f98519f',
    messagingSenderId: '547028898766',
    projectId: 'task-app-85e6d',
    databaseURL: 'https://task-app-85e6d-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'task-app-85e6d.firebasestorage.app',
    iosBundleId: 'com.example.taskApp',
  );
}
