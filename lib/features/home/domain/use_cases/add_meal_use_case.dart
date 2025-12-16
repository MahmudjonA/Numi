import 'package:numi/features/home/domain/entities/meal.dart';
import 'package:numi/features/home/domain/repositories/meal_repo.dart';

class AddMealUseCase {
  final MealRepo mealRepo;

  AddMealUseCase(this.mealRepo);

  Future<Meal> call(Meal meal) {
    return mealRepo.addMeal(meal: meal);
  }
}
