import 'package:numi/features/home/domain/entities/meal.dart';

abstract class MealState {
  const MealState();
}

class MealInitial extends MealState {}

class MealLoading extends MealState {}

class MealLoaded extends MealState {
  final List<Meal> meals;

  const MealLoaded({required this.meals});
}

class MealError extends MealState {
  final String message;

  const MealError({required this.message});
}
