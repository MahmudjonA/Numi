import 'package:numi/features/home/domain/entities/meal.dart';

abstract class MealRepo {
  Future<Meal> addMeal({required Meal meal});
  Future<List<Meal>> getMeal();
  Future<void> deleteMeal({required String id});
}