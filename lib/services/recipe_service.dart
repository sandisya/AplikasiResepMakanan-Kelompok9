import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe_model.dart';

class RecipeService {
  final recipes = FirebaseFirestore.instance.collection("recipes");

  // CREATE
  Future addRecipe(Recipe r) async {
    final doc = recipes.doc();
    await doc.set(r.toMap());
  }

  // UPDATE
  Future updateRecipe(Recipe r) async {
    await recipes.doc(r.id).update(r.toMap());
  }

  // DELETE
  Future deleteRecipe(String id) async {
    await recipes.doc(id).delete();
  }

  // ALL RECIPES
  Stream<List<Recipe>> getAllRecipes() {
    return recipes.snapshots().map(
      (snap) => snap.docs
          .map((d) => Recipe.fromFirestore(d.data(), d.id))
          .toList(),
    );
  }

  // POPULAR ONLY
  Stream<List<Recipe>> getPopularRecipes() {
    return recipes
        .where("isPopular", isEqualTo: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => Recipe.fromFirestore(d.data(), d.id))
            .toList());
  }

  // CATEGORIES
  Stream<List<String>> getCategories() {
    return recipes.snapshots().map((snap) {
      final setCats = snap.docs
          .map((d) => d["category"]?.toString() ?? "")
          .where((e) => e.isNotEmpty)
          .toSet();
      return setCats.toList();
    });
  }
}
