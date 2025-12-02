import 'package:flutter/material.dart';
import '../models/recipe_model.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;
  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  bool isFavorite = false;
  bool isSaved = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.orange),
        title: const Text('DapurKu', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border, color: Colors.orange),
            onPressed: () {
              setState(() => isSaved = !isSaved);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(isSaved ? 'Resep disimpan' : 'Resep dihapus dari simpanan'), duration: const Duration(seconds: 1)),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  widget.recipe.image,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: double.infinity,
                    height: 250,
                    color: Colors.grey[300],
                    child: const Icon(Icons.restaurant, size: 80, color: Colors.grey),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text('${widget.recipe.time} min', style: const TextStyle(color: Colors.white, fontSize: 12))
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(widget.recipe.title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold))),
                      IconButton(
                        icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.red, size: 28),
                        onPressed: () {
                          setState(() => isFavorite = !isFavorite);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(isFavorite ? 'Ditambahkan ke favorit' : 'Dihapus dari favorit'), duration: const Duration(seconds: 1)),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(12)),
                    child: Text(widget.recipe.category, style: TextStyle(color: Colors.orange[800], fontWeight: FontWeight.w600, fontSize: 13)),
                  ),
                  if (widget.recipe.isPopular) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: const [
                        Icon(Icons.star, color: Colors.amber, size: 20),
                        SizedBox(width: 4),
                        Text('4.5', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(' (120 reviews)', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                  const Divider(height: 30),
                  const Text('Bahan-bahan', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildIngredient('200g bahan utama'),
                  _buildIngredient('100g bahan pelengkap'),
                  _buildIngredient('2 sdm bumbu'),
                  _buildIngredient('Garam dan merica secukupnya'),
                  const Divider(height: 30),
                  const Text('Cara Membuat', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ...List.generate(
                    widget.recipe.steps.length,
                    (index) => _buildStep(index + 1, widget.recipe.steps[index]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredient(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }

  Widget _buildStep(int number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
            child: Center(
              child: Text('$number', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15, height: 1.5))),
        ],
      ),
    );
  }
}