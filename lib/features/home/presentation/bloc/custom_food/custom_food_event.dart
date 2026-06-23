import '../../../domain/entities/custom_food.dart';

abstract class CustomFoodEvent {
  const CustomFoodEvent();
}

class LoadCustomFoodsEvent extends CustomFoodEvent {}

class AddCustomFoodEvent extends CustomFoodEvent {
  final CustomFood food;
  const AddCustomFoodEvent({required this.food});
}

class DeleteCustomFoodEvent extends CustomFoodEvent {
  final String id;
  const DeleteCustomFoodEvent({required this.id});
}
