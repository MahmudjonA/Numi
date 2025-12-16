import '../entities/meal.dart';
import '../repositories/meal_repo.dart';

class GetMealsUseCase {
  final MealRepo repo;

  GetMealsUseCase(this.repo);

  Future<List<Meal>> call() {
    return repo.getMeal();
  }
}
