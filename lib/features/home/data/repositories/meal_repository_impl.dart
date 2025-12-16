import '../../domain/entities/meal.dart';
import '../../domain/repositories/meal_repo.dart';
import '../data_sources/local/meal_local_data_source.dart';
import '../models/meal_model.dart';

class MealRepositoryImpl implements MealRepo {
  final MealLocalDataSource localDataSource;

  MealRepositoryImpl(this.localDataSource);

  @override
  Future<Meal> addMeal({required Meal meal}) async {
    final model = MealModel.fromEntity(meal);
    await localDataSource.addMeal(model);
    return meal;
  }

  @override
  Future<List<Meal>> getMeal() async {
    final models = await localDataSource.getMeals();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> deleteMeal({required String id}) async {
    await localDataSource.deleteMeal(id);
  }
}
