import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../firebase_options.dart';

class FirebaseAppService {
  static FirebaseAuth get auth => FirebaseAuth.instance;
  static FirebaseFirestore get firestore => FirebaseFirestore.instance;

  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  static Future<UserCredential> signInWithEmailPassword(String email, String password) async {
    return auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  static Future<UserCredential> registerWithEmailPassword(String email, String password) async {
    final credential = await auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    await saveUserProfile(
      uid: credential.user!.uid,
      email: credential.user!.email ?? email.trim(),
      displayName: credential.user!.displayName ?? email.trim().split('@').first,
    );

    return credential;
  }

  static Future<void> saveUserProfile({
    required String uid,
    required String email,
    String? displayName,
  }) async {
    await firestore.collection('users').doc(uid).set({
      'uid': uid,
      'email': email,
      'displayName': displayName ?? email.split('@').first,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'role': 'customer',
      'app': 'FreshPress',
    }, SetOptions(merge: true));
  }

  static Future<void> signOut() async {
    await auth.signOut();
  }
}
