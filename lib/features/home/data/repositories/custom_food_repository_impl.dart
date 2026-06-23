import '../../domain/entities/custom_food.dart';
import '../../domain/repositories/custom_food_repo.dart';
import '../data_sources/local/custom_food_local_data_source.dart';
import '../models/custom_food_model.dart';

class CustomFoodRepositoryImpl implements CustomFoodRepo {
  final CustomFoodLocalDataSource dataSource;

  CustomFoodRepositoryImpl(this.dataSource);

  @override
  Future<List<CustomFood>> getAll() async {
    final models = await dataSource.getAll();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> add(CustomFood food) async {
    await dataSource.add(CustomFoodModel.fromEntity(food));
  }

  @override
  Future<void> delete(String id) async {
    await dataSource.delete(id);
  }
}
