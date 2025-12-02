import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe_model.dart';
import 'login_screen.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;
  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  bool isFavorite = false;
  bool isSaved = false;

  final uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  // 🔥 CEK STATUS FAVORIT & SAVED DI FIRESTORE
  Future<void> _loadStatus() async {
    if (uid == null) return;

    final favDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("favorites")
        .doc(widget.recipe.id)
        .get();

    final savedDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("saved")
        .doc(widget.recipe.id)
        .get();

    setState(() {
      isFavorite = favDoc.exists;
      isSaved = savedDoc.exists;
    });
  }

  // 🚨 POPUP LOGIN
  void _showLoginAlert() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Login Diperlukan"),
        content: const Text("Silakan login untuk menggunakan fitur ini."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            child: const Text("Login"),
          ),
        ],
      ),
    );
  }

  // 🎉 TOAST MODERN
  void _showCoolToast(String message, IconData icon, Color color) {
    final overlay = Overlay.of(context);

    final entry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 40,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.85),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);

    Future.delayed(const Duration(seconds: 2)).then((_) => entry.remove());
  }

  // ❤️ TOGGLE FAVORITE
  Future<void> _toggleFavorite() async {
    if (uid == null) {
      _showLoginAlert();
      return;
    }

    final ref = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("favorites")
        .doc(widget.recipe.id);

    if (isFavorite) {
      await ref.delete();
      _showCoolToast(
          "Dihapus dari favorit", Icons.favorite_border, Colors.white);
    } else {
      await ref.set(widget.recipe.toMap());
      _showCoolToast("Ditambahkan ke favorit", Icons.favorite, Colors.red);
    }

    setState(() => isFavorite = !isFavorite);
  }

  // 🔖 TOGGLE SAVED
  Future<void> _toggleSaved() async {
    if (uid == null) {
      _showLoginAlert();
      return;
    }

    final ref = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("saved")
        .doc(widget.recipe.id);

    if (isSaved) {
      await ref.delete();
      _showCoolToast("Resep dibatalkan", Icons.bookmark_border, Colors.white);
    } else {
      await ref.set(widget.recipe.toMap());
      _showCoolToast(
          "Resep berhasil disimpan", Icons.bookmark, Colors.orange);
    }

    setState(() => isSaved = !isSaved);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.orange),
        title: const Text(
          'DapurKu',
          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.orange,
            ),
            onPressed: _toggleSaved,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            Stack(
              children: [
                Image.network(
                  widget.recipe.image,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time,
                            color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.recipe.time} min',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITLE + FAVORITE BUTTON
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.recipe.title,
                          style: const TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                          size: 28,
                        ),
                        onPressed: _toggleFavorite,
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // CATEGORY BADGE
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.recipe.category,
                      style: TextStyle(
                          color: Colors.orange[800],
                          fontWeight: FontWeight.w600),
                    ),
                  ),

                  const Divider(height: 30),

                  // INGREDIENTS
                  const Text(
                    'Bahan-bahan',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  ...widget.recipe.ingredients
                      .map((i) => _buildIngredient(i))
                      .toList(),

                  const Divider(height: 30),

                  // STEPS
                  const Text(
                    'Cara Membuat',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  ...List.generate(
                    widget.recipe.steps.length,
                    (i) => _buildStep(i + 1, widget.recipe.steps[i]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Ingredient Item UI
  Widget _buildIngredient(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 15)),
          ),
        ],
      ),
    );
  }

  // Step Item UI
  Widget _buildStep(int number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
