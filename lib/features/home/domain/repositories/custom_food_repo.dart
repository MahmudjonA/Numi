import '../entities/custom_food.dart';

abstract class CustomFoodRepo {
  Future<List<CustomFood>> getAll();
  Future<void> add(CustomFood food);
  Future<void> delete(String id);
}
