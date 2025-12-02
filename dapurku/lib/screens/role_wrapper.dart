import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart';
import 'admin_screen.dart';
import 'login_screen.dart';

class RoleWrapper extends StatelessWidget {
  const RoleWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        // Belum login → arahkan ke login
        if (!snap.hasData) return const LoginScreen();

        final user = snap.data!;

        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .get(),
          builder: (context, roleSnap) {
            if (!roleSnap.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final data = roleSnap.data!.data() as Map<String, dynamic>?;
            final role = data?['role'] ?? 'user';

            return role == 'admin'
                ? const AdminScreen()
                : const HomeScreen();
          },
        );
      },
    );
  }
}
