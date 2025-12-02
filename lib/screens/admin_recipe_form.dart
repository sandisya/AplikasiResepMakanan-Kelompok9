import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import '../services/recipe_service.dart';

class AdminRecipeForm extends StatefulWidget {
  final Recipe? recipe;
  const AdminRecipeForm({super.key, this.recipe});

  @override
  State<AdminRecipeForm> createState() => _AdminRecipeFormState();
}

class _AdminRecipeFormState extends State<AdminRecipeForm> {
  final _service = RecipeService();

  final titleC = TextEditingController();
  final imageC = TextEditingController();
  final categoryC = TextEditingController();
  final timeC = TextEditingController();
  bool isPopular = false;

  List<TextEditingController> ingredientsControllers = [];
  List<TextEditingController> stepsControllers = [];

  @override
  void initState() {
    super.initState();

    if (widget.recipe != null) {
      final r = widget.recipe!;

      titleC.text = r.title;
      imageC.text = r.image;
      categoryC.text = r.category;
      timeC.text = r.time.toString();
      isPopular = r.isPopular;

      // LOAD INGREDIENTS
      for (var s in r.ingredients) {
        ingredientsControllers.add(TextEditingController(text: s));
      }

      // LOAD STEPS
      for (var s in r.steps) {
        stepsControllers.add(TextEditingController(text: s));
      }
    } else {
      ingredientsControllers.add(TextEditingController());
      stepsControllers.add(TextEditingController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: Text(widget.recipe == null ? "Add Recipe" : "Edit Recipe"),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // IMAGE PREVIEW
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                  color: Colors.black.withOpacity(0.1),
                )
              ],
              image: imageC.text.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(imageC.text),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imageC.text.isEmpty
                ? const Center(
                    child: Text("Image Preview",
                        style: TextStyle(color: Colors.black54)),
                  )
                : null,
          ),

          const SizedBox(height: 15),

          TextField(
            controller: imageC,
            decoration: InputDecoration(
              labelText: "Image URL",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.image),
            ),
            onChanged: (v) => setState(() {}),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: titleC,
            decoration: InputDecoration(
              labelText: "Title",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.title),
            ),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: categoryC,
            decoration: InputDecoration(
              labelText: "Category",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.category),
            ),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: timeC,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Time (mins)",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.timer),
            ),
          ),

          SwitchListTile(
            title: const Text("Popular Recipe?"),
            value: isPopular,
            onChanged: (v) => setState(() => isPopular = v),
            activeColor: Colors.orange,
          ),

          const SizedBox(height: 25),

          // ================= INGREDIENTS INPUT =================
          const Text(
            "Ingredients",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Column(
            children: ingredientsControllers.map((c) {
              final index = ingredientsControllers.indexOf(c);

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                      color: Colors.black.withOpacity(0.08),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: c,
                        decoration: InputDecoration(
                          labelText: "Ingredient ${index + 1}",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        setState(() {
                          ingredientsControllers.remove(c);
                        });
                      },
                    )
                  ],
                ),
              );
            }).toList(),
          ),

          TextButton.icon(
            onPressed: () {
              setState(() {
                ingredientsControllers.add(TextEditingController());
              });
            },
            icon: const Icon(Icons.add),
            label: const Text("Add Ingredient"),
          ),

          const SizedBox(height: 25),

          // ================= STEPS INPUT =================
          const Text(
            "Steps",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Column(
            children: stepsControllers.map((c) {
              final index = stepsControllers.indexOf(c);

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                      color: Colors.black.withOpacity(0.08),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: c,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: "Step ${index + 1}",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        setState(() {
                          stepsControllers.remove(c);
                        });
                      },
                    )
                  ],
                ),
              );
            }).toList(),
          ),

          TextButton.icon(
            onPressed: () {
              setState(() {
                stepsControllers.add(TextEditingController());
              });
            },
            icon: const Icon(Icons.add),
            label: const Text("Add Step"),
          ),

          const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.all(14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: saveRecipe,
              child: const Text(
                "SAVE",
                style: TextStyle(fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }

  // ================= SAVE FUNCTION ======================
  void saveRecipe() async {
    final ingredients = ingredientsControllers
        .map((c) => c.text)
        .where((s) => s.isNotEmpty)
        .toList();

    final steps = stepsControllers
        .map((c) => c.text)
        .where((s) => s.isNotEmpty)
        .toList();

    final recipe = Recipe(
      id: widget.recipe?.id ?? "",
      title: titleC.text,
      image: imageC.text,
      category: categoryC.text,
      time: int.tryParse(timeC.text) ?? 0,
      isPopular: isPopular,
      ingredients: ingredients,
      steps: steps,
    );

    if (widget.recipe == null) {
      await _service.addRecipe(recipe);
    } else {
      await _service.updateRecipe(recipe);
    }

    Navigator.pop(context);
  }
}
