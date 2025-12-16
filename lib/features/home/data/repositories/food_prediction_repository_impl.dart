import 'dart:io';
import 'package:numi/features/home/data/data_sources/remote/food_prediction_remote_data_source.dart';
import 'package:numi/features/home/data/models/food_prediction_model.dart';
import 'package:numi/features/home/domain/repositories/food_prediction_repo.dart';

class FoodPredictionImpl extends FoodPredictionRepo {
  final FoodPredictionRemoteDataSource remoteDataSource;

  FoodPredictionImpl({required this.remoteDataSource});

  @override
  Future<FoodPredictionModel> getFoodPrediction({required File image}) async {
    return remoteDataSource.predictFoodImage(image: image);
  }
}
