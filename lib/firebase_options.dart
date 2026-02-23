// Generado manualmente desde Firebase Console
// Proyecto: arcana-education
// Fecha: 2026-02-19

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
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError('macOS no soportado');
      case TargetPlatform.windows:
        throw UnsupportedError('Windows no soportado');
      case TargetPlatform.linux:
        throw UnsupportedError('Linux no soportado');
      default:
        throw UnsupportedError('Plataforma no soportada');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCyij-wNZsTU6L1yXsvQDYh9Os32mzFUlg',
    appId: '1:266489815428:web:67fe0c3858087667053dd1',
    messagingSenderId: '266489815428',
    projectId: 'arcana-education',
    authDomain: 'arcana-education.firebaseapp.com',
    storageBucket: 'arcana-education.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD36JwA4ljRdj_drBRfCa12-S_ky97m7vg',
    appId: '1:266489815428:android:1af538e5f7916019053dd1',
    messagingSenderId: '266489815428',
    projectId: 'arcana-education',
    storageBucket: 'arcana-education.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAlIccwpg7toIKbrrwrC5hxsvwYF-3UXNY',
    appId: '1:266489815428:ios:d5d2ed9b7f2d634e053dd1',
    messagingSenderId: '266489815428',
    projectId: 'arcana-education',
    storageBucket: 'arcana-education.firebasestorage.app',
    iosBundleId: 'com.antigravity.arcana',
  );
}
