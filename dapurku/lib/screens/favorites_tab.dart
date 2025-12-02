import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import 'recipe_detail_screen.dart';

class FavoritesTab extends StatelessWidget {
  const FavoritesTab({super.key});

  @override
  Widget build(BuildContext context) {
    // For demo: static list. Replace with Firestore query for user's favorites.
    final favorites = [
      Recipe(
        id: '1',
        title: 'Spaghetti Bolognese',
        image: 'https://via.placeholder.com/300',
        category: 'Italian',
        time: 30,
        isPopular: true,
        steps: [
          'Rebus spaghetti sesuai petunjuk kemasan hingga al dente.',
          'Tumis bawang bombay dan bawang putih hingga harum.',
          'Masukkan daging cincang, masak hingga berubah warna.',
          'Tambahkan tomat kalengan, bumbui dengan garam dan merica.',
          'Sajikan spaghetti dengan saus bolognese di atasnya.'
        ],
      ),
      Recipe(
        id: '2',
        title: 'Grilled Chicken',
        image: 'https://via.placeholder.com/300',
        category: 'Western',
        time: 45,
        isPopular: false,
        steps: [
          'Marinasi ayam dengan bumbu selama 30 menit.',
          'Panaskan grill atau pan dengan api sedang.',
          'Panggang ayam hingga matang dan berwarna kecoklatan.',
          'Sajikan dengan sayuran dan saus favorit.'
        ],
      ),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('DapurKu', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange)),
                Icon(Icons.search, color: Colors.orange)
              ],
            ),
            const SizedBox(height: 20),
            const Text('Favorites', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (_, i) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        favorites[i].image,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[300],
                          child: const Icon(Icons.restaurant, color: Colors.grey),
                        ),
                      ),
                    ),
                    title: Text(favorites[i].title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Row(
                      children: [
                        Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text('${favorites[i].time} min', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            favorites[i].category,
                            style: TextStyle(fontSize: 11, color: Colors.orange[800], fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.favorite, color: Colors.red),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RecipeDetailScreen(recipe: favorites[i]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}