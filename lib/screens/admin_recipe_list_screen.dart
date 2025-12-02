import 'package:flutter/material.dart';
import '../services/recipe_service.dart';
import '../models/recipe_model.dart';
import 'admin_recipe_form.dart';

class AdminRecipeListScreen extends StatelessWidget {
  final RecipeService _service = RecipeService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: const Text(
          "Manage Recipes",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),

      // FAB ======================================================
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, size: 28),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AdminRecipeForm()),
          );
        },
      ),

      // LIST ======================================================
      body: StreamBuilder<List<Recipe>>(
        stream: _service.getAllRecipes(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final recipes = snapshot.data!;
          if (recipes.isEmpty) {
            return const Center(
              child: Text(
                "No recipes yet",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: recipes.length,
            itemBuilder: (_, i) {
              final r = recipes[i];

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                      color: Colors.black.withOpacity(0.08),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    // Thumbnail ==============================
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                      child: r.image.isNotEmpty
                          ? Image.network(
                              r.image,
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 90,
                              height: 90,
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.image, size: 30),
                            ),
                    ),

                    // Title + category ========================
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              r.title,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              r.category,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ACTION BUTTONS ===========================
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AdminRecipeForm(recipe: r),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  title: const Text("Delete Recipe?"),
                                  content: const Text(
                                      "Are you sure you want to delete this recipe?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(ctx),
                                      child: const Text("Cancel"),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      onPressed: () {
                                        _service.deleteRecipe(r.id);
                                        Navigator.pop(ctx);
                                      },
                                      child: const Text("Delete"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
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
