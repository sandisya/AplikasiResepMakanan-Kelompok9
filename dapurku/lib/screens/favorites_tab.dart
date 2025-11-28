import 'package:flutter/material.dart';
import 'recipe_detail_screen.dart';

class FavoritesTab extends StatelessWidget {
  const FavoritesTab({super.key});

  @override
  Widget build(BuildContext context) {
    // For demo: static list. Replace with Firestore query for user's favorites.
    final favorites = ['Spaghetti Bolognese', 'Grilled Chicken'];
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
            Text('DapurKu', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange)),
            Icon(Icons.search)
          ]),
          const SizedBox(height: 20),
          const Text('Favorites', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (_, i) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: SizedBox(width: 56, child: Image.network('https://via.placeholder.com/80')),
                  title: Text(favorites[i]),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RecipeDetailScreen(title: favorites[i]))),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}