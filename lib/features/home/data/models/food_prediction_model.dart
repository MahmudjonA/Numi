import 'package:numi/features/home/domain/entities/food_prediction.dart';

class FoodPredictionModel extends FoodPrediction {
  FoodPredictionModel({
    required super.name,
    required super.score,
  });

  factory FoodPredictionModel.fromJson(Map<String, dynamic> json) {
    final concept = json["outputs"][0]["data"]["concepts"][0];

    return FoodPredictionModel(
      name: concept["name"],
      score: (concept["value"] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "score": score,
    };
  }
}
