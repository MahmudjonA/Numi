class Meal {
  final String id;
  final String name;
  final int calories;
  final String category;
  final DateTime dateTime;
  final String? imagePath;

  const Meal({
    required this.id,
    required this.name,
    required this.calories,
    required this.category,
    required this.dateTime,
    this.imagePath,
  });
}

class Meals {
  final DateTime date;
  List<Meal> meals;

  Meals({required this.meals, required this.date});
}
