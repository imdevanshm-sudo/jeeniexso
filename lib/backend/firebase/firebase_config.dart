import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyADRWkeUf8yVx8yAE6y67mK1oso-eVrdPo",
            authDomain: "jeeniverse-faa8e.firebaseapp.com",
            projectId: "jeeniverse-faa8e",
            storageBucket: "jeeniverse-faa8e.firebasestorage.app",
            messagingSenderId: "304099374260",
            appId: "1:304099374260:web:3394c66830ac04170e53e1",
            measurementId: "G-NS2RZ3KE5T"));
  } else {
    await Firebase.initializeApp();
  }
}
