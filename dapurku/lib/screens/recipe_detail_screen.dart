import 'package:flutter/material.dart';

class RecipeDetailScreen extends StatelessWidget {
  final String title;
  const RecipeDetailScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.orange), title: const Text('DapurKu', style: TextStyle(color: Colors.orange))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(height: 180, child: Image.network('https://via.placeholder.com/300')),
          const SizedBox(height: 18),
          const Text('Ingredients', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('- 200g spaghetti\n- 100g minced beef\n- 1 onion, chopped\n- 400g canned tomatoes'),
          const SizedBox(height: 14),
          const Text('Steps', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('1. Cook spaghetti according to package.\n2. Saute onion & garlic.\n3. Add beef then tomatoes. Simmer.'),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          // toggle favorite (implement with Firestore)
        },
        child: const Icon(Icons.favorite_border),
      ),
    );
  }
}