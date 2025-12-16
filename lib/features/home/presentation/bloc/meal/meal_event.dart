import 'package:numi/features/home/domain/entities/meal.dart';

abstract class MealEvent {
  const MealEvent();
}

/// load all meals
class LoadMealsEvent extends MealEvent {}

/// add new meal
class AddMealEvent extends MealEvent {
  final Meal meal;

  const AddMealEvent({required this.meal});
}

/// delete meal
class DeleteMealEvent extends MealEvent {
  final String id;

  const DeleteMealEvent({required this.id});
}
