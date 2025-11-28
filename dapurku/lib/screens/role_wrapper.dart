import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart';  // FIX
import 'admin_screen.dart';

class RoleWrapper extends StatelessWidget {
  const RoleWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, userSnap) {
        if (userSnap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        if (!userSnap.hasData) {
          return const Scaffold(
            body: Center(child: Text("No user logged in")),
          );
        }

        final user = userSnap.data!;

        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get(),
          builder: (context, roleSnap) {
            if (roleSnap.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                  body: Center(child: CircularProgressIndicator()));
            }

            if (!roleSnap.hasData || !roleSnap.data!.exists) {
              return const Scaffold(
                body: Center(child: Text("Profile not found")),
              );
            }

            final data = roleSnap.data!.data() as Map<String, dynamic>;
            final role = data['role'] ?? 'user';

            if (role == 'admin') return const AdminScreen();
            return const HomeScreen(); // FIX
          },
        );
      },
    );
  }
}
