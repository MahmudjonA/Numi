import '../entities/custom_food.dart';
import '../repositories/custom_food_repo.dart';

class AddCustomFoodUseCase {
  final CustomFoodRepo repo;
  AddCustomFoodUseCase(this.repo);
  Future<void> call(CustomFood food) => repo.add(food);
}
