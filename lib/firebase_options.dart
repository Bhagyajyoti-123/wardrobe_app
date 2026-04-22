import 'package:firebase_core/firebase_core.dart'
    show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    return web;
  }

static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD7DT5ZT9nLQpsfS58LelmGHs-q2kg6Kag',
    appId: '1:384938342662:web:d8edc0b1ec63062e4c8687',
    messagingSenderId: '384938342662',
    projectId: 'wardrobe-app-7ca0',
    authDomain: 'wardrobe-app-7ca08.firebaseapp.com',
    storageBucket: 'wardrobe-app-7ca08.firebasestorage.app',
  
  );
}