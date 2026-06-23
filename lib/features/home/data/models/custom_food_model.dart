import 'package:hive/hive.dart';
import '../../domain/entities/custom_food.dart';
part 'custom_food_model.g.dart';

@HiveType(typeId: 2)
class CustomFoodModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int calories;

  @HiveField(3)
  final double proteinG;

  @HiveField(4)
  final double carbsG;

  @HiveField(5)
  final double fatG;

  @HiveField(6)
  final String? category;

  CustomFoodModel({
    required this.id,
    required this.name,
    required this.calories,
    this.proteinG = 0.0,
    this.carbsG = 0.0,
    this.fatG = 0.0,
    this.category,
  });

  factory CustomFoodModel.fromEntity(CustomFood food) => CustomFoodModel(
        id: food.id,
        name: food.name,
        calories: food.calories,
        proteinG: food.proteinG,
        carbsG: food.carbsG,
        fatG: food.fatG,
        category: food.category,
      );

  CustomFood toEntity() => CustomFood(
        id: id,
        name: name,
        calories: calories,
        proteinG: proteinG,
        carbsG: carbsG,
        fatG: fatG,
        category: category,
      );
}
