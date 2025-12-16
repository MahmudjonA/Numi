import 'dart:io';

import 'package:numi/features/home/data/models/food_prediction_model.dart';

abstract class FoodPredictionRemoteDataSource {
  Future<FoodPredictionModel> predictFoodImage({
    required File image,
  });
}