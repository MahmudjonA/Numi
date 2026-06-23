import '../../../domain/entities/custom_food.dart';

abstract class CustomFoodState {
  const CustomFoodState();
}

class CustomFoodInitial extends CustomFoodState {}

class CustomFoodLoading extends CustomFoodState {}

class CustomFoodLoaded extends CustomFoodState {
  final List<CustomFood> foods;
  const CustomFoodLoaded({required this.foods});
}

class CustomFoodError extends CustomFoodState {
  final String message;
  const CustomFoodError({required this.message});
}
