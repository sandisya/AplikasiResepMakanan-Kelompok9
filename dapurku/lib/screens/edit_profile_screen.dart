import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  const EditProfileScreen({super.key, required this.userData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.userData['name']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, iconTheme: const IconThemeData(color: Colors.orange), title: const Text('Edit Profile', style: TextStyle(color: Colors.orange))),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () async {
              final uid = widget.userData['uid'] ?? FirebaseFirestore.instance; // adapt if you include uid
              // update logic (assumes user doc path known)
              // For demo: just pop
              Navigator.pop(context);
            },
            child: const Text('Save'),
          )
        ]),
      ),
    );
  }
}