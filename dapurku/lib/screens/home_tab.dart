import 'package:flutter/material.dart';
import '../services/recipe_service.dart';
import '../models/recipe_model.dart';
import 'recipe_detail_screen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final RecipeService _service = RecipeService();

  String _search = "";
  String? _selectedCategory; // <-- selected category (null = no filter)

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

            /// SEARCH BOX
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xffF6EFE6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                onChanged: (v) {
                  setState(() => _search = v.toLowerCase());
                },
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search recipes',
                    icon: Icon(Icons.search)),
              ),
            ),

            const SizedBox(height: 26),

            // -------------------------------------------
            //                 CATEGORIES
            // -------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Categories",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange),
                ),
                // Clear filter button
                if (_selectedCategory != null)
                  TextButton(
                    onPressed: () => setState(() => _selectedCategory = null),
                    child: const Text("Clear", style: TextStyle(color: Colors.orange)),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            SizedBox(
              height: 90,
              child: StreamBuilder<List<String>>(
                stream: _service.getCategories(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final categories = snapshot.data!;
                  if (categories.isEmpty) {
                    return const Center(child: Text("No categories"));
                  }

                  // Apply search to categories as well (so user can find category)
                  final filteredCats = _search.isEmpty
                      ? categories
                      : categories
                          .where((c) => c.toLowerCase().contains(_search))
                          .toList();

                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: filteredCats
                        .map((c) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: _categoryCard(c),
                            ))
                        .toList(),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // -------------------------------------------
            //             POPULAR RECIPES
            // -------------------------------------------
            const Text(
              "Popular Recipes",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange),
            ),
            const SizedBox(height: 14),

            SizedBox(
              height: 200,
              child: StreamBuilder<List<Recipe>>(
                stream: _service.getPopularRecipes(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  List<Recipe> recipes = snapshot.data!;

                  // Apply category filter if selected
                  if (_selectedCategory != null) {
                    recipes = recipes
                        .where((r) => r.category.toLowerCase() == _selectedCategory!.toLowerCase())
                        .toList();
                  }

                  // Apply text search filter
                  if (_search.isNotEmpty) {
                    recipes = recipes
                        .where((r) =>
                            r.title.toLowerCase().contains(_search) ||
                            r.category.toLowerCase().contains(_search))
                        .toList();
                  }

                  if (recipes.isEmpty) {
                    return const Center(child: Text("No popular recipes"));
                  }

                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: recipes
                        .map((r) => Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: _recipeCard(context, r),
                            ))
                        .toList(),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            // -------------------------------------------
            //                ALL RECIPES
            // -------------------------------------------
            const Text(
              "All Recipes",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange),
            ),
            const SizedBox(height: 14),

            StreamBuilder<List<Recipe>>(
              stream: _service.getAllRecipes(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                List<Recipe> recipes = snapshot.data!;

                // Apply category filter if selected
                if (_selectedCategory != null) {
                  recipes = recipes
                      .where((r) => r.category.toLowerCase() == _selectedCategory!.toLowerCase())
                      .toList();
                }

                // Apply text search filter
                if (_search.isNotEmpty) {
                  recipes = recipes
                      .where((r) =>
                          r.title.toLowerCase().contains(_search) ||
                          r.category.toLowerCase().contains(_search))
                      .toList();
                }

                if (recipes.isEmpty) {
                  return const Text("No recipes found", style: TextStyle(fontSize: 16));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recipes.length,
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _recipeCardLarge(context, recipes[i]),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // CATEGORY CARD (clickable — sets _selectedCategory)
  Widget _categoryCard(String title) {
    final isSelected = _selectedCategory != null && _selectedCategory!.toLowerCase() == title.toLowerCase();

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            // toggle off if clicked again
            _selectedCategory = null;
          } else {
            _selectedCategory = title;
          }
        });
      },
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.orange.shade50,
          borderRadius: BorderRadius.circular(14),
          border: isSelected ? Border.all(color: Colors.deepOrange, width: 2) : null,
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  // POPULAR CARD
  Widget _recipeCard(BuildContext context, Recipe recipe) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipe: recipe)),
      ),
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xffFFF8F0),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: recipe.image.isNotEmpty
                  ? Image.network(recipe.image, height: 90, fit: BoxFit.cover)
                  : Icon(Icons.image, size: 90, color: Colors.grey[300]),
            ),
            const SizedBox(height: 8),
            Text(
              recipe.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.orange, size: 16),
                const SizedBox(width: 6),
                Text("${recipe.time} mins"),
              ],
            )
          ],
        ),
      ),
    );
  }

  // LIST VERSION FOR ALL RECIPES
  Widget _recipeCardLarge(BuildContext context, Recipe recipe) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipe: recipe)),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xffFFF8F0),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: recipe.image.isNotEmpty
                  ? Image.network(recipe.image, width: 90, height: 90, fit: BoxFit.cover)
                  : Container(
                      width: 90,
                      height: 90,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, color: Colors.white),
                    ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(recipe.title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(recipe.category, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.timer, size: 16, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text("${recipe.time} mins"),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
