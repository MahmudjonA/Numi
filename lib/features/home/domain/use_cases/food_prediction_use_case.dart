import 'dart:io';
import 'package:numi/features/home/domain/entities/food_prediction.dart';
import 'package:numi/features/home/domain/repositories/food_prediction_repo.dart';

class FoodPredictionUseCase {
  final FoodPredictionRepo foodPredictionRepository;
  FoodPredictionUseCase(this.foodPredictionRepository);

  Future<FoodPrediction> call({required File image}) async {
    return await foodPredictionRepository.getFoodPrediction(image: image);
  }


}