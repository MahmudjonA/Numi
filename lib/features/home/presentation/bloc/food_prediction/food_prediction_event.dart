import 'dart:io';

abstract class FoodPredictionEvent {
  const FoodPredictionEvent();
}

class PredictFoodImageEvent extends FoodPredictionEvent {
  final File image;

  const PredictFoodImageEvent({required this.image});
}
