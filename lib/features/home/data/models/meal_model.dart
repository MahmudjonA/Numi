import 'package:hive/hive.dart';
import '../../domain/entities/meal.dart';

part 'meal_model.g.dart';
@HiveType(typeId: 0)
class MealModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int calories;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final DateTime dateTime;

  @HiveField(5)
  final String? imagePath;

  MealModel({
    required this.id,
    required this.name,
    required this.calories,
    required this.category,
    required this.dateTime,
    this.imagePath,
  });

  /// Entity → Model
  factory MealModel.fromEntity(Meal meal) {
    return MealModel(
      id: meal.id,
      name: meal.name,
      calories: meal.calories,
      category: meal.category,
      dateTime: meal.dateTime,
      imagePath: meal.imagePath,
    );
  }

  /// Model → Entity
  Meal toEntity() {
    return Meal(
      id: id,
      name: name,
      calories: calories,
      category: category,
      dateTime: dateTime,
      imagePath: imagePath,
    );
  }
}

