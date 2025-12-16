import 'package:hive/hive.dart';
import '../../models/meal_model.dart';
import 'meal_local_data_source.dart';
import '../../../../../core/logger.dart';

class MealLocalDataSourceImpl implements MealLocalDataSource {
  static const String _boxName = 'meals';

  Box<MealModel> get _box => Hive.box<MealModel>(_boxName);

  @override
  Future<void> addMeal(MealModel meal) async {
    try {
      LoggerService.info(
        '📦 [Hive] Adding meal: ${meal.name} (id=${meal.id})',
      );

      await _box.put(meal.id, meal);

      LoggerService.debug(
        '✅ [Hive] Meal saved. Total meals: ${_box.length}',
      );
    } catch (e) {
      LoggerService.error(
        '❌ [Hive] Failed to add meal: ${meal.id} | Error: $e',
      );
      rethrow;
    }
  }

  @override
  Future<List<MealModel>> getMeals() async {
    try {
      LoggerService.info('📦 [Hive] Fetching meals...');

      final meals = _box.values.toList();

      LoggerService.debug(
        '📊 [Hive] Meals fetched: ${meals.length}',
      );

      return meals;
    } catch (e) {
      LoggerService.error(
        '❌ [Hive] Failed to fetch meals | Error: $e',
      );
      rethrow;
    }
  }

  @override
  Future<void> deleteMeal(String id) async {
    try {
      LoggerService.warning(
        '🗑️ [Hive] Deleting meal with id=$id',
      );

      await _box.delete(id);

      LoggerService.debug(
        '🧹 [Hive] Meal deleted. Total meals: ${_box.length}',
      );
    } catch (e) {
      LoggerService.error(
        '❌ [Hive] Failed to delete meal: $id | Error: $e',
      );
      rethrow;
    }
  }
}
