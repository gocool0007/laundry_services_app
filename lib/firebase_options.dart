import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: 'YOUR_API_KEY',
      appId: 'YOUR_APP_ID',
      messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
      projectId: 'Firebase-63a3c',
      storageBucket: 'Firebase-63a3c.appspot.com',
      iosBundleId: 'com.freshpress.laundry',
      androidPackageName: 'com.freshpress.laundry',
    );
  }
}
