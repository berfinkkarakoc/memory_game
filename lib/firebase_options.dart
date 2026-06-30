import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform, kIsWeb;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA-fakeKeyForSecurity12345',
    appId: '1:123456789:web:fakeId',
    messagingSenderId: '123456789',
    projectId: 'memorygame-f245f',
    authDomain: 'memorygame-f245f.firebaseapp.com',
    storageBucket: 'memorygame-f245f.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA4vqpCBWnw1bOyW7yQ_xXT2yrDOgwdU78',
    appId: '1:397314226775:android:1efd15a587b9212e978112',
    messagingSenderId: '397314226775',
    projectId: 'memorygame-f245f',
    storageBucket: 'memorygame-f245f.firebasestorage.app',
  );
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCI-bIEznPS_WkHj3yPH9gieCPim4jvL1s',
    appId: '1:397314226775:ios:86d05ea2e93eda18978112',
    messagingSenderId: '397314226775',
    projectId: 'memorygame-f245f',
    storageBucket: 'memorygame-f245f.firebasestorage.app',
    iosBundleId: 'com.example.memoryGame',
  );
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA-fakeKeyMacOS12345',
    appId: '1:123456789:ios:fakeId',
    messagingSenderId: '123456789',
    projectId: 'memorygame-f245f',
    storageBucket: 'memorygame-f245f.appspot.com',
    iosBundleId: 'com.example.memoryGame',
  );
}
