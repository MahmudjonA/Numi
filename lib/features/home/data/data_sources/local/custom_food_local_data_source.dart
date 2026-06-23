import '../../models/custom_food_model.dart';

abstract class CustomFoodLocalDataSource {
  Future<List<CustomFoodModel>> getAll();
  Future<void> add(CustomFoodModel food);
  Future<void> delete(String id);
}
