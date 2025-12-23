const Map<String, int> foodCalories = {
  // Fruits
  'apple': 95,        // 1 medium apple
  'banana': 105,      // 1 medium banana
  'cherries': 75,     // 1 cup
  'strawberry': 50,   // 1 cup
  'watermelon': 90,   // 1 slice / cup


  // Bread
  'bread_slice': 80,
  'toast_slice': 75,
  'baguette_slice': 90,
  'flatbread_slice': 70,
  'lavash_bread': 120,

  // Eggs
  'boiled_egg': 78,
  'fried_egg': 196,

  // Drinks (standard portions)
  'soda': 80, // 200 ml
  'juice': 90, // 200 ml
  'milk': 82, // 200 ml (2.5%)
  'coffee': 2, // black coffee, no sugar
  'coffee_with_sugar': 32, // 1 cup (200 ml, 2 tsp sugar)
  'tea': 2, // green tea, no sugar
  'sweet_tea': 32, // 1 cup (200 ml, 2 tsp sugar)


  // Vegetables
  'carrot': 41,
  'tomato': 18,

  // Fast Food
  'burger': 280,       // 1 medium burger
  'pizza_slice': 270,  // 1 slice
  'shawarma': 430,     // 1 wrap

};

int getCaloriesByName(String mealName) {
  final key = mealName.toLowerCase();

  return foodCalories[key] ?? 200; // fallback
}
