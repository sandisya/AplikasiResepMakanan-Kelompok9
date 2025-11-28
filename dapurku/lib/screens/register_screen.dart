import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  bool loading = false;

  Future register() async {
    if (loading) return;

    setState(() => loading = true);

    try {
      // 1. Daftarkan user
      UserCredential cred =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: passCtrl.text.trim(),
      );

      // 2. Simpan role default ke Firestore
      await FirebaseFirestore.instance
          .collection("users")
          .doc(cred.user!.uid)
          .set({"role": "user"});

      // 3. Tunggu firestore menulis
      await Future.delayed(const Duration(milliseconds: 300));

      if (!mounted) return;

      // 4. LOGOUT dulu biar benar-benar kembali ke login
      await FirebaseAuth.instance.signOut();

      // 5. Pindah ke LOGIN SCREEN
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registrasi berhasil, silakan login")),
      );

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }

    if (mounted) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passCtrl,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),

            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: register,
                    child: const Text("Register"),
                  ),
          ],
        ),
      ),
    );
  }
}
