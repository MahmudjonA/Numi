import '../../models/meal_model.dart';

abstract class MealLocalDataSource {
  Future<void> addMeal(MealModel meal);
  Future<List<MealModel>> getMeals();
  Future<void> deleteMeal(String id);
}
