import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  User? get currentUser => auth.currentUser;
  Stream<User?> get authStateChanges => auth.authStateChanges();

  Future<UserCredential> register(String name, String email, String password) async {
    final cred = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await firestore.collection('users').doc(cred.user!.uid).set({
      'name': name,
      'email': email,
      'role': 'user',
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return cred;
  }

  Future<UserCredential> login(String email, String password) {
    return auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> logout() => auth.signOut();
}
