const Map<String, int> foodCalories = {
  // Fruits
  'apple': 52,
  'banana': 89,
  'orange': 47,

  // Bread
  'bread_slice': 80,
  'toast_slice': 75,
  'baguette_slice': 90,
  'flatbread_slice': 70,
  'lavash_bread' : 120,


  // Eggs
  'egg': 155,
  'fried_egg': 196,

  // Drinks
  'soda': 40,
  'juice': 45,

  // Vegetables
  'carrot': 41,
  'tomato': 18,

  // Default fallback
};

int getCaloriesByName(String mealName) {
  final key = mealName.toLowerCase();

  return foodCalories[key] ?? 200; // fallback
}