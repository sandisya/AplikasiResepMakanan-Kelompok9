class Recipe {
  String id;
  String title;
  String image;
  String category;
  int time;
  bool isPopular;
  List<String> ingredients;
  List<String> steps;

  Recipe({
    required this.id,
    required this.title,
    required this.image,
    required this.category,
    required this.time,
    required this.isPopular,
    required this.ingredients,
    required this.steps,
  });

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "image": image,
      "category": category,
      "time": time,
      "isPopular": isPopular,
      "ingredients": ingredients,
      "steps": steps,
    };
  }

  factory Recipe.fromFirestore(Map<String, dynamic> map, String docId) {
    return Recipe(
      id: docId,
      title: map["title"]?.toString() ?? "",
      image: map["image"]?.toString() ?? "",
      category: map["category"]?.toString() ?? "",
      time: map["time"] is int ? map["time"] : int.tryParse(map["time"].toString()) ?? 0,
      isPopular: map["isPopular"] == true,
      ingredients: _safeList(map["ingredients"]),
      steps: _safeList(map["steps"]),
    );
  }

  /// Mengubah dynamic list Firestore → List<String> (mencegah crash)
  static List<String> _safeList(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }
}
