enum MealType { Breakfast, Lunch, Dinner, Snack }

class Meal {
  final String id;
  final String name;
  final int calories;
  final String category;
  final DateTime dateTime;
  final String? imagePath;
  final MealType mealType;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final double? portionGrams;
  final bool isCustom;

  const Meal({
    required this.id,
    required this.name,
    required this.calories,
    required this.category,
    required this.dateTime,
    this.imagePath,
    this.mealType = MealType.Snack,
    this.proteinG = 0.0,
    this.carbsG = 0.0,
    this.fatG = 0.0,
    this.portionGrams,
    this.isCustom = false,
  });
}

class Meals {
  final DateTime date;
  List<Meal> meals;

  Meals({required this.meals, required this.date});
}
