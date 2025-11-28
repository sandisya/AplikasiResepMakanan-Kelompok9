import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_profile_screen.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future _loadUser() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    setState(() => userData = doc.data());
  }

  @override
  Widget build(BuildContext context) {
    if (userData == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              Text('DapurKu', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange)),
              const SizedBox(height: 12),
              const Text('Profile', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              CircleAvatar(radius: 48, backgroundImage: NetworkImage('https://via.placeholder.com/150')),
              const SizedBox(height: 12),
              Text(userData!['name'] ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(userData!['email'] ?? ''),
              const SizedBox(height: 12),

              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EditProfileScreen(userData: userData!))),
                child: const Text('Edit Profile'),
              ),

              const SizedBox(height: 20),
              Row(children: [
                Expanded(child: _statCard('Saved Recipes', '25')),
                const SizedBox(width: 12),
                Expanded(child: _statCard('Favorites', '10')),
              ]),

              const SizedBox(height: 20),
              ListTile(leading: const Icon(Icons.settings, color: Colors.orange), title: const Text('Settings')), 
              ListTile(leading: const Icon(Icons.help_outline, color: Colors.orange), title: const Text('Help')),
              ListTile(leading: const Icon(Icons.logout, color: Colors.orange), title: const Text('Logout'), onTap: () async {
                await FirebaseAuth.instance.signOut();
                // navigate back to login
                Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
              }),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _statCard(String title, String value) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(12)),
        child: Column(children: [Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), const SizedBox(height: 6), Text(title)]),
      );
}