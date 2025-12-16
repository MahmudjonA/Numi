import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numi/features/home/domain/use_cases/food_prediction_use_case.dart';
import 'package:numi/features/home/presentation/bloc/food_prediction/food_prediction_event.dart';

import 'food_prediction_state.dart';

class FoodPredictionBloc
    extends Bloc<FoodPredictionEvent, FoodPredictionState> {
  final FoodPredictionUseCase getFoodPredictionUseCase;

  FoodPredictionBloc(this.getFoodPredictionUseCase)
    : super(FoodPredictionInitial()) {
    on<PredictFoodImageEvent>((event, emit) async {
      emit(FoodPredictionLoading());
      try {
        final result = await getFoodPredictionUseCase(image: event.image);
        emit(FoodPredictionSuccess(predictionResult: result));
      } catch (e) {
        emit(FoodPredictionError(message: e.toString()));
      }
    });
  }
}
