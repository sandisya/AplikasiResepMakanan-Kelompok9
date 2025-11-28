import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/recipe_service.dart';
import '../models/recipe_model.dart';
import 'recipe_detail_screen.dart';

class HomeTab extends StatelessWidget {
  HomeTab({super.key});

  final RecipeService _service = RecipeService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'DapurKu',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                Icon(Icons.search, color: Colors.orange),
              ],
            ),

            const SizedBox(height: 16),

            /// SEARCH
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xffF6EFE6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search recipes',
                    icon: Icon(Icons.search)),
              ),
            ),

            const SizedBox(height: 26),

            // -------------------------------------------
            //        CATEGORIES (FROM FIRESTORE)
            // -------------------------------------------
            const Text(
              "Categories",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange),
            ),
            const SizedBox(height: 14),

            SizedBox(
              height: 90,
              child: StreamBuilder<List<String>>(
                stream: _service.getCategories(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final categories = snapshot.data!;

                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: categories
                        .map((c) => _categoryCard(c))
                        .toList(),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // -------------------------------------------
            //        POPULAR RECIPES (FROM FIRESTORE)
            // -------------------------------------------
            const Text(
              "Popular Recipes",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange),
            ),
            const SizedBox(height: 14),

            StreamBuilder<List<Recipe>>(
              stream: _service.getPopularRecipes(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final recipes = snapshot.data!;

                return Row(
                  children: [
                    for (int i = 0; i < recipes.length; i++)
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: i == 0 ? 12 : 0),
                          child: _recipeCard(context, recipes[i]),
                        ),
                      ),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }

  /// Category Card
  Widget _categoryCard(String title) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Text(title,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w500)),
      ),
    );
  }

  /// Recipe card
  Widget _recipeCard(BuildContext context, Recipe recipe) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => RecipeDetailScreen(title: recipe.title)),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xffFFF8F0),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child:
                  Image.network(recipe.image, height: 90, fit: BoxFit.cover),
            ),
            const SizedBox(height: 8),
            Text(
              recipe.title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.access_time,
                    color: Colors.orange, size: 16),
                const SizedBox(width: 6),
                Text("${recipe.time} Mins"),
              ],
            )
          ],
        ),
      ),
    );
  }
}
