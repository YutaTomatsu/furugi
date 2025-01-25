import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAN48pXFNqTGklWSbN8ekIfNUP_hPh5QQk",
            authDomain: "furugi-with-template-40pf0j.firebaseapp.com",
            projectId: "furugi-with-template-40pf0j",
            storageBucket: "furugi-with-template-40pf0j.appspot.com",
            messagingSenderId: "456437395005",
            appId: "1:456437395005:web:1196f156a34e0f7fc54454"));
  } else {
    await Firebase.initializeApp();
  }
}
