import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe_model.dart';
import 'recipe_detail_screen.dart';
import 'login_screen.dart';

class FavoritesTab extends StatelessWidget {
  const FavoritesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'DapurKu',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange),
                ),
                Icon(Icons.search, color: Colors.orange),
              ],
            ),

            const SizedBox(height: 20),

            // Jika belum login
            if (user == null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info, color: Colors.orange),
                    const SizedBox(width: 10),
                    const Expanded(
                        child: Text("Login untuk melihat resep favorit.")),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      ),
                      child: const Text("Login"),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),
            const Text("Favorites",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            // Jika belum login
            if (user == null)
              const Expanded(
                child: Center(
                  child: Text(
                    "Belum ada resep favorit",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              ),

            // 🔥 STREAM DATA FAVORITES DARI:
            // users / {uid} / favorites / {recipeId}
            if (user != null)
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(user.uid)
                      .collection("favorites")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                          child: CircularProgressIndicator());
                    }

                    final docs = snapshot.data!.docs;

                    if (docs.isEmpty) {
                      return const Center(
                        child: Text(
                          "Belum ada resep favorit",
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    final favorites = docs
                        .map((doc) =>
                            Recipe.fromFirestore(doc.data(), doc.id))
                        .toList();

                    return ListView.builder(
                      itemCount: favorites.length,
                      itemBuilder: (_, i) {
                        final food = favorites[i];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                food.image,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(food.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            trailing: const Icon(Icons.favorite,
                                color: Colors.red),

                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    RecipeDetailScreen(recipe: food),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
