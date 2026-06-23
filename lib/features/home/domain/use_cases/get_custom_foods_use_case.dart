import '../entities/custom_food.dart';
import '../repositories/custom_food_repo.dart';

class GetCustomFoodsUseCase {
  final CustomFoodRepo repo;
  GetCustomFoodsUseCase(this.repo);
  Future<List<CustomFood>> call() => repo.getAll();
}
