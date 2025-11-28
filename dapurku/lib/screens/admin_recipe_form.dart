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

  List<TextEditingController> stepsControllers = [];

  @override
  void initState() {
    super.initState();

    if (widget.recipe != null) {
      titleC.text = widget.recipe!.title;
      imageC.text = widget.recipe!.image;
      categoryC.text = widget.recipe!.category;
      timeC.text = widget.recipe!.time.toString();
      isPopular = widget.recipe!.isPopular;

      for (var s in widget.recipe!.steps) {
        stepsControllers.add(TextEditingController(text: s));
      }
    } else {
      stepsControllers.add(TextEditingController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe == null ? "Add Recipe" : "Edit Recipe"),
        backgroundColor: Colors.orange,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(controller: titleC, decoration: const InputDecoration(labelText: "Title")),
          TextField(controller: imageC, decoration: const InputDecoration(labelText: "Image URL")),
          TextField(controller: categoryC, decoration: const InputDecoration(labelText: "Category")),
          TextField(controller: timeC, decoration: const InputDecoration(labelText: "Time (mins)")),
          SwitchListTile(
            title: const Text("Popular Recipe?"),
            value: isPopular,
            onChanged: (v) => setState(() => isPopular = v),
          ),

          const SizedBox(height: 20),
          const Text("Steps", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),

          Column(
            children: stepsControllers.map((c) {
              final index = stepsControllers.indexOf(c);
              return Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: c,
                      decoration: InputDecoration(labelText: "Step ${index + 1}"),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        stepsControllers.remove(c);
                      });
                    },
                  )
                ],
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

          ElevatedButton(
            onPressed: saveRecipe,
            child: const Text("SAVE"),
          )
        ],
      ),
    );
  }

  void saveRecipe() async {
    final steps =
        stepsControllers.map((c) => c.text).where((s) => s.isNotEmpty).toList();

    final recipe = Recipe(
      id: widget.recipe?.id ?? "",
      title: titleC.text,
      image: imageC.text,
      category: categoryC.text,
      time: int.parse(timeC.text),
      isPopular: isPopular,
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
