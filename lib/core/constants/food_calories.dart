class FoodInfo {
  final int calories;
  final double proteinG;
  final double carbsG;
  final double fatG;

  const FoodInfo({
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });
}

const Map<String, FoodInfo> foodDatabase = {
  // ── Fruits ──────────────────────────────────────────────
  'apple':       FoodInfo(calories: 95,  proteinG: 0.5, carbsG: 25.0, fatG: 0.3),
  'banana':      FoodInfo(calories: 105, proteinG: 1.3, carbsG: 27.0, fatG: 0.4),
  'cherries':    FoodInfo(calories: 75,  proteinG: 1.0, carbsG: 19.0, fatG: 0.2),
  'strawberry':  FoodInfo(calories: 50,  proteinG: 1.0, carbsG: 12.0, fatG: 0.5),
  'water_melon': FoodInfo(calories: 90,  proteinG: 1.8, carbsG: 22.0, fatG: 0.2),
  'orange':      FoodInfo(calories: 62,  proteinG: 1.2, carbsG: 15.0, fatG: 0.2),
  'grape':       FoodInfo(calories: 104, proteinG: 1.1, carbsG: 27.0, fatG: 0.2),
  'mango':       FoodInfo(calories: 135, proteinG: 0.9, carbsG: 35.0, fatG: 0.6),
  'pear':        FoodInfo(calories: 102, proteinG: 0.6, carbsG: 27.0, fatG: 0.2),
  'peach':       FoodInfo(calories: 59,  proteinG: 1.4, carbsG: 14.0, fatG: 0.4),

  // ── Vegetables ──────────────────────────────────────────
  'carrot':      FoodInfo(calories: 41,  proteinG: 0.9, carbsG: 10.0, fatG: 0.2),
  'tomato':      FoodInfo(calories: 18,  proteinG: 0.9, carbsG: 3.9,  fatG: 0.2),
  'salad':       FoodInfo(calories: 15,  proteinG: 1.3, carbsG: 2.9,  fatG: 0.2),
  'cucumber':    FoodInfo(calories: 16,  proteinG: 0.7, carbsG: 3.6,  fatG: 0.1),
  'potato':      FoodInfo(calories: 77,  proteinG: 2.0, carbsG: 17.0, fatG: 0.1),
  'broccoli':    FoodInfo(calories: 55,  proteinG: 3.7, carbsG: 11.0, fatG: 0.6),
  'cabbage':     FoodInfo(calories: 25,  proteinG: 1.3, carbsG: 5.8,  fatG: 0.1),
  'onion':       FoodInfo(calories: 44,  proteinG: 1.2, carbsG: 10.0, fatG: 0.1),
  'pepper':      FoodInfo(calories: 31,  proteinG: 1.0, carbsG: 7.6,  fatG: 0.3),
  'spinach':     FoodInfo(calories: 23,  proteinG: 2.9, carbsG: 3.6,  fatG: 0.4),

  // ── Bread & Grains ──────────────────────────────────────
  'bread_slice':    FoodInfo(calories: 80,  proteinG: 2.7, carbsG: 15.0, fatG: 1.0),
  'toast_slice':    FoodInfo(calories: 75,  proteinG: 2.5, carbsG: 14.0, fatG: 1.0),
  'baguette_slice': FoodInfo(calories: 90,  proteinG: 3.0, carbsG: 18.0, fatG: 0.5),
  'flatbread_slice':FoodInfo(calories: 70,  proteinG: 2.5, carbsG: 15.0, fatG: 0.5),
  'lavash_bread':   FoodInfo(calories: 120, proteinG: 3.5, carbsG: 24.0, fatG: 1.5),
  'rice':           FoodInfo(calories: 206, proteinG: 4.3, carbsG: 45.0, fatG: 0.4),
  'oatmeal':        FoodInfo(calories: 150, proteinG: 5.0, carbsG: 27.0, fatG: 3.0),
  'pasta':          FoodInfo(calories: 220, proteinG: 8.0, carbsG: 43.0, fatG: 1.3),
  'buckwheat':      FoodInfo(calories: 155, proteinG: 5.7, carbsG: 33.0, fatG: 1.0),
  'corn':           FoodInfo(calories: 132, proteinG: 4.6, carbsG: 29.0, fatG: 1.8),

  // ── Eggs ────────────────────────────────────────────────
  'boiled_egg': FoodInfo(calories: 78,  proteinG: 6.3, carbsG: 0.6,  fatG: 5.3),
  'fried_egg':  FoodInfo(calories: 196, proteinG: 13.6,carbsG: 1.6,  fatG: 14.8),
  'omelette':   FoodInfo(calories: 154, proteinG: 10.6,carbsG: 1.7,  fatG: 12.0),

  // ── Dairy ───────────────────────────────────────────────
  'milk':         FoodInfo(calories: 82,  proteinG: 4.0, carbsG: 5.9,  fatG: 3.9),
  'yogurt':       FoodInfo(calories: 100, proteinG: 4.3, carbsG: 13.0, fatG: 3.3),
  'cheese':       FoodInfo(calories: 113, proteinG: 7.0, carbsG: 0.4,  fatG: 9.0),
  'butter':       FoodInfo(calories: 102, proteinG: 0.1, carbsG: 0.0,  fatG: 11.5),
  'cottage_cheese':FoodInfo(calories:98,  proteinG: 11.0,carbsG: 3.4,  fatG: 4.3),
  'kefir':        FoodInfo(calories: 63,  proteinG: 3.3, carbsG: 4.5,  fatG: 3.5),

  // ── Meat ────────────────────────────────────────────────
  'chicken':      FoodInfo(calories: 165, proteinG: 31.0,carbsG: 0.0,  fatG: 3.6),
  'meat':         FoodInfo(calories: 250, proteinG: 26.0,carbsG: 0.0,  fatG: 15.0),
  'beef':         FoodInfo(calories: 215, proteinG: 26.0,carbsG: 0.0,  fatG: 12.0),
  'pork':         FoodInfo(calories: 242, proteinG: 27.0,carbsG: 0.0,  fatG: 14.0),
  'turkey':       FoodInfo(calories: 189, proteinG: 29.0,carbsG: 0.0,  fatG: 7.0),
  'lamb':         FoodInfo(calories: 294, proteinG: 25.0,carbsG: 0.0,  fatG: 20.0),

  // ── Seafood ─────────────────────────────────────────────
  'fish':   FoodInfo(calories: 136, proteinG: 20.0,carbsG: 0.0,  fatG: 6.0),
  'shrimp': FoodInfo(calories: 99,  proteinG: 18.0,carbsG: 1.0,  fatG: 2.0),
  'salmon': FoodInfo(calories: 208, proteinG: 20.0,carbsG: 0.0,  fatG: 13.0),
  'tuna':   FoodInfo(calories: 128, proteinG: 29.0,carbsG: 0.0,  fatG: 1.0),
  'crab':   FoodInfo(calories: 87,  proteinG: 18.0,carbsG: 0.0,  fatG: 1.5),

  // ── Drinks ──────────────────────────────────────────────
  'soda':             FoodInfo(calories: 80,  proteinG: 0.0, carbsG: 21.0, fatG: 0.0),
  'juice':            FoodInfo(calories: 90,  proteinG: 0.5, carbsG: 22.0, fatG: 0.1),
  'milk_drink':       FoodInfo(calories: 82,  proteinG: 4.0, carbsG: 5.9,  fatG: 3.9),
  'coffee':           FoodInfo(calories: 2,   proteinG: 0.3, carbsG: 0.0,  fatG: 0.0),
  'coffee_with_sugar':FoodInfo(calories: 32,  proteinG: 0.3, carbsG: 8.0,  fatG: 0.0),
  'tea':              FoodInfo(calories: 2,   proteinG: 0.0, carbsG: 0.0,  fatG: 0.0),
  'sweet_tea':        FoodInfo(calories: 32,  proteinG: 0.0, carbsG: 8.0,  fatG: 0.0),
  'smoothie':         FoodInfo(calories: 150, proteinG: 3.0, carbsG: 35.0, fatG: 1.0),
  'energy_drink':     FoodInfo(calories: 110, proteinG: 1.0, carbsG: 28.0, fatG: 0.0),

  // ── Fast Food ───────────────────────────────────────────
  'burger':      FoodInfo(calories: 280, proteinG: 14.0,carbsG: 30.0, fatG: 12.0),
  'pizza_slice': FoodInfo(calories: 270, proteinG: 12.0,carbsG: 33.0, fatG: 10.0),
  'shawarma':    FoodInfo(calories: 430, proteinG: 20.0,carbsG: 40.0, fatG: 20.0),
  'hot_dog':     FoodInfo(calories: 290, proteinG: 11.0,carbsG: 24.0, fatG: 17.0),
  'french_fries':FoodInfo(calories: 312, proteinG: 3.4, carbsG: 41.0, fatG: 15.0),
  'sandwich':    FoodInfo(calories: 350, proteinG: 18.0,carbsG: 38.0, fatG: 12.0),

  // ── Sweets ──────────────────────────────────────────────
  'cake':        FoodInfo(calories: 350, proteinG: 4.0, carbsG: 55.0, fatG: 13.0),
  'candy':       FoodInfo(calories: 70,  proteinG: 0.0, carbsG: 18.0, fatG: 0.0),
  'chocolate':   FoodInfo(calories: 155, proteinG: 2.0, carbsG: 18.0, fatG: 9.0),
  'croissant':   FoodInfo(calories: 231, proteinG: 4.7, carbsG: 26.0, fatG: 12.0),
  'ice_cream':   FoodInfo(calories: 137, proteinG: 2.3, carbsG: 17.0, fatG: 7.0),
  'cookie':      FoodInfo(calories: 148, proteinG: 1.5, carbsG: 21.0, fatG: 7.0),
  'donut':       FoodInfo(calories: 253, proteinG: 3.6, carbsG: 29.0, fatG: 14.0),

  // ── Nuts & Legumes ──────────────────────────────────────
  'almond':      FoodInfo(calories: 164, proteinG: 6.0, carbsG: 6.0,  fatG: 14.0),
  'walnut':      FoodInfo(calories: 185, proteinG: 4.3, carbsG: 3.9,  fatG: 18.5),
  'peanut':      FoodInfo(calories: 166, proteinG: 7.3, carbsG: 6.1,  fatG: 14.0),
  'lentils':     FoodInfo(calories: 116, proteinG: 9.0, carbsG: 20.0, fatG: 0.4),
  'chickpeas':   FoodInfo(calories: 164, proteinG: 8.9, carbsG: 27.0, fatG: 2.6),
  'beans':       FoodInfo(calories: 127, proteinG: 8.7, carbsG: 22.0, fatG: 0.5),
};

FoodInfo? getFoodInfo(String mealName) {
  final key = mealName.toLowerCase().replaceAll(' ', '_');
  return foodDatabase[key];
}

int getCaloriesByName(String mealName) {
  return getFoodInfo(mealName)?.calories ?? 200;
}
