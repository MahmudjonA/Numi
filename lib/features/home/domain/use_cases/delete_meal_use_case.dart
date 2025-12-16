import '../repositories/meal_repo.dart';

class DeleteMealUseCase {
  final MealRepo repo;

  DeleteMealUseCase(this.repo);

  Future<void> call(String id) {
    return repo.deleteMeal(id: id);
  }
}
