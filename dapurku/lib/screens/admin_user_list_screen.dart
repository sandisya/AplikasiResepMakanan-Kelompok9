import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminUserListScreen extends StatelessWidget {
  const AdminUserListScreen({super.key});

  void changeRole(BuildContext context, String uid, String currentRole) async {
    final newRole = currentRole == "admin" ? "user" : "admin";

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({"role": newRole});

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Role changed to $newRole")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Manage Users"),
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs;

          if (users.isEmpty) {
            return const Center(child: Text("No users found"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (_, i) {
              final u = users[i];
              final data = u.data() as Map<String, dynamic>;

              final id = u.id;
              final email = data["email"] ?? "No Email";
              final role = data["role"] ?? "user";

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                      color: Colors.black12,
                    )
                  ],
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 25,
                      child: Icon(Icons.person, size: 28),
                    ),
                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(email,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              )),
                          Text("Role: $role",
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 13)),
                        ],
                      ),
                    ),

                    IconButton(
                      icon: const Icon(Icons.swap_horiz, color: Colors.orange),
                      onPressed: () => changeRole(context, id, role),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
