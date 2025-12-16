import 'dart:io';

import 'package:numi/features/home/domain/entities/food_prediction.dart';

abstract class FoodPredictionRepo {
  Future<FoodPrediction> getFoodPrediction({required File image});
}

