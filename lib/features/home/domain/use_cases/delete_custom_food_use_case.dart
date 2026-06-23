import '../repositories/custom_food_repo.dart';

class DeleteCustomFoodUseCase {
  final CustomFoodRepo repo;
  DeleteCustomFoodUseCase(this.repo);
  Future<void> call(String id) => repo.delete(id);
}
