// File konfigurasi Firebase Options otomatis untuk Android, Windows, iOS, dan Web
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.iOS:
        return ios;
      default:
        return android;
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBy9HmS0YxFGDZf5adD9o504eeSsbJbi_o',
    appId: '1:738635318814:android:586f7db50d992a697f100f',
    messagingSenderId: '738635318814',
    projectId: 'antiburnout-1c07d',
    storageBucket: 'antiburnout-1c07d.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBy9HmS0YxFGDZf5adD9o504eeSsbJbi_o',
    appId: '1:738635318814:web:586f7db50d992a697f100f',
    messagingSenderId: '738635318814',
    projectId: 'antiburnout-1c07d',
    storageBucket: 'antiburnout-1c07d.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBy9HmS0YxFGDZf5adD9o504eeSsbJbi_o',
    appId: '1:738635318814:web:586f7db50d992a697f100f',
    messagingSenderId: '738635318814',
    projectId: 'antiburnout-1c07d',
    storageBucket: 'antiburnout-1c07d.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBy9HmS0YxFGDZf5adD9o504eeSsbJbi_o',
    appId: '1:738635318814:ios:586f7db50d992a697f100f',
    messagingSenderId: '738635318814',
    projectId: 'antiburnout-1c07d',
    storageBucket: 'antiburnout-1c07d.firebasestorage.app',
  );
}

