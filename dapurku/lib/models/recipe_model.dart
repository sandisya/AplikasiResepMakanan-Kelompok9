class Recipe {
  String id;
  String title;
  String image;
  String category;
  int time;
  bool isPopular;
  List<String> steps;

  Recipe({
    required this.id,
    required this.title,
    required this.image,
    required this.category,
    required this.time,
    required this.isPopular,
    required this.steps,
  });

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "image": image,
      "category": category,
      "time": time,
      "isPopular": isPopular,
      "steps": steps,
    };
  }

  factory Recipe.fromFirestore(Map<String, dynamic> map, String docId) {
    return Recipe(
      id: docId,
      title: map["title"] ?? "",
      image: map["image"] ?? "",
      category: map["category"] ?? "",
      time: map["time"] ?? 0,
      isPopular: map["isPopular"] ?? false,
      steps: List<String>.from(map["steps"] ?? []),
    );
  }
}
