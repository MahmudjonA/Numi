import 'package:hive/hive.dart';
import '../../models/custom_food_model.dart';
import 'custom_food_local_data_source.dart';

class CustomFoodLocalDataSourceImpl implements CustomFoodLocalDataSource {
  static const String _boxName = 'custom_foods';

  Box<CustomFoodModel> get _box => Hive.box<CustomFoodModel>(_boxName);

  @override
  Future<List<CustomFoodModel>> getAll() async {
    return _box.values.toList();
  }

  @override
  Future<void> add(CustomFoodModel food) async {
    await _box.put(food.id, food);
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }
}
