import 'package:flutter/material.dart';
import '../services/recipe_service.dart';
import '../models/recipe_model.dart';
import 'admin_recipe_form.dart';

class AdminRecipeListScreen extends StatelessWidget {
  final RecipeService _service = RecipeService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Recipes"), backgroundColor: Colors.orange),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AdminRecipeForm()),
          );
        },
      ),
      body: StreamBuilder<List<Recipe>>(
        stream: _service.getAllRecipes(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final recipes = snapshot.data!;

          if (recipes.isEmpty) {
            return const Center(child: Text("No recipes"));
          }

          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (_, i) {
              final r = recipes[i];

              return ListTile(
                title: Text(r.title),
                subtitle: Text(r.category),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
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
                      icon: const Icon(Icons.delete),
                      onPressed: () => _service.deleteRecipe(r.id),
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
