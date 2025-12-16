import 'dart:convert';
import 'dart:io';

import '../../../../../core/dio/dio_client.dart';
import '../../../../../core/logger.dart';
import '../../models/food_prediction_model.dart';
import 'food_prediction_remote_data_source.dart';

class FoodPredictionRemoteDataSourceImpl
    extends FoodPredictionRemoteDataSource {
  final DioClient dioClient = DioClient();

  static const String _apiKey = "61d8d7c04433493d952f78e67377ec96";
  static const String _modelId = "food-item-recognition";
  static const String _modelVersion = "1d5fd481e0cf4826aa72ec3ff049e044";

  FoodPredictionRemoteDataSourceImpl() {
    dioClient.setApiKey(_apiKey);
  }

  @override
  Future<FoodPredictionModel> predictFoodImage({required File image}) async {
    try {
      LoggerService.info("Reading image bytes...");
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);

      final String path = "models/$_modelId/versions/$_modelVersion/outputs";

      LoggerService.debug("Sending request to Clarifai...");

      final response = await dioClient.post(
        path,
        data: {
          "inputs": [
            {
              "data": {
                "image": {"base64": base64Image},
              },
            },
          ],
        },
      );

      LoggerService.info("Clarifai response received");

      return FoodPredictionModel.fromJson(response.data);
    } catch (e) {
      LoggerService.error("Clarifai error: $e");
      rethrow;
    }
  }
}
