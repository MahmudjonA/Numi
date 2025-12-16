import 'package:numi/features/home/domain/entities/food_prediction.dart';

abstract class FoodPredictionState {
  const FoodPredictionState();
}

class FoodPredictionInitial extends FoodPredictionState {}

class FoodPredictionLoading extends FoodPredictionState {}

class FoodPredictionSuccess extends FoodPredictionState {
  final FoodPrediction predictionResult;

  const FoodPredictionSuccess({required this.predictionResult});
}

class FoodPredictionError extends FoodPredictionState {
  final String message;

  const FoodPredictionError({required this.message});
}
