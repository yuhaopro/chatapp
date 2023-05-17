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
    apiKey: 'AIzaSyDeln4MyU8ulkoTpsjamhyDlqytgtGx5oY',
    appId: '1:1015144719724:web:a03b1700ec7792210dbf49',
    messagingSenderId: '1015144719724',
    projectId: 'chatapp-8cf21',
    authDomain: 'chatapp-8cf21.firebaseapp.com',
    storageBucket: 'chatapp-8cf21.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAhzphIF6GrrwBnbjGDRfTn_wWbngTsiIc',
    appId: '1:1015144719724:android:52c6ca96ab5af37c0dbf49',
    messagingSenderId: '1015144719724',
    projectId: 'chatapp-8cf21',
    storageBucket: 'chatapp-8cf21.appspot.com',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDkBm9_n43kJ501QegbTJRvbKPFHHji2GM',
    appId: '1:1015144719724:ios:2fb36768d282f7fb0dbf49',
    messagingSenderId: '1015144719724',
    projectId: 'chatapp-8cf21',
    storageBucket: 'chatapp-8cf21.appspot.com',
    androidClientId: '1015144719724-6iftd4ujaah3oo003upldsn9nbo4fk0i.apps.googleusercontent.com',
    iosClientId: '1015144719724-6sk22ra8lev9nj825i06u5aev8npso2a.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatapp',
  );
}
