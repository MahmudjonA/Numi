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

  @HiveField(6)
  final int mealType; // MealType enum index

  @HiveField(7)
  final double proteinG;

  @HiveField(8)
  final double carbsG;

  @HiveField(9)
  final double fatG;

  @HiveField(10)
  final double? portionGrams;

  @HiveField(11)
  final bool isCustom;

  MealModel({
    required this.id,
    required this.name,
    required this.calories,
    required this.category,
    required this.dateTime,
    this.imagePath,
    this.mealType = 3,
    this.proteinG = 0.0,
    this.carbsG = 0.0,
    this.fatG = 0.0,
    this.portionGrams,
    this.isCustom = false,
  });

  factory MealModel.fromEntity(Meal meal) {
    return MealModel(
      id: meal.id,
      name: meal.name,
      calories: meal.calories,
      category: meal.category,
      dateTime: meal.dateTime,
      imagePath: meal.imagePath,
      mealType: meal.mealType.index,
      proteinG: meal.proteinG,
      carbsG: meal.carbsG,
      fatG: meal.fatG,
      portionGrams: meal.portionGrams,
      isCustom: meal.isCustom,
    );
  }

  Meal toEntity() {
    return Meal(
      id: id,
      name: name,
      calories: calories,
      category: category,
      dateTime: dateTime,
      imagePath: imagePath,
      mealType: MealType.values[mealType],
      proteinG: proteinG,
      carbsG: carbsG,
      fatG: fatG,
      portionGrams: portionGrams,
      isCustom: isCustom,
    );
  }
}
