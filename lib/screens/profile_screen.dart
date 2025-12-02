import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future loadUser() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      setState(() => loading = false);
      return;
    }

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    setState(() {
      userData = doc.data();
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              children: [
                const Text(
                  "DapurKu",
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25),

                // ============================
                // 🔥 GUEST MODE
                // ============================
                if (user == null) ...[
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: const [
                        Icon(Icons.person_outline,
                            size: 80, color: Colors.orange),
                        SizedBox(height: 16),
                        Text(
                          "Anda belum login",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Login untuk menyimpan resep favorit, membuat daftar, dan mengakses fitur lengkap.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const LoginScreen()),
                      ),
                      child: const Text(
                        "Login Sekarang",
                        style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],

                // ============================
                // 🔥 LOGGED IN MODE
                // ============================
                if (user != null) ...[
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      userData?["photoUrl"] ??
                          "https://via.placeholder.com/150",
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    userData?["name"] ?? "User",
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    userData?["email"] ?? user.email ?? "",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              EditProfileScreen(userData: userData!),
                        ),
                      );
                    },
                    child: const Text("Edit Profile"),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: _statCard("Saved Recipes",
                            (userData?["saved_count"] ?? 0).toString()),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _statCard("Favorites",
                            (userData?["favorite_count"] ?? 0).toString()),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  ListTile(
                    leading: const Icon(Icons.settings, color: Colors.orange),
                    title: const Text("Settings"),
                  ),
                  ListTile(
                    leading:
                        const Icon(Icons.help_outline, color: Colors.orange),
                    title: const Text("Help"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.orange),
                    title: const Text("Logout"),
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      if (!mounted) return;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const LoginScreen()),
                      );
                    },
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(title),
        ],
      ),
    );
  }
}
