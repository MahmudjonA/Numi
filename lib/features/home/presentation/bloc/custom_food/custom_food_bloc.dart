import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/add_custom_food_use_case.dart';
import '../../../domain/use_cases/delete_custom_food_use_case.dart';
import '../../../domain/use_cases/get_custom_foods_use_case.dart';
import 'custom_food_event.dart';
import 'custom_food_state.dart';

class CustomFoodBloc extends Bloc<CustomFoodEvent, CustomFoodState> {
  final AddCustomFoodUseCase addUseCase;
  final GetCustomFoodsUseCase getUseCase;
  final DeleteCustomFoodUseCase deleteUseCase;

  CustomFoodBloc(this.addUseCase, this.getUseCase, this.deleteUseCase)
      : super(CustomFoodInitial()) {
    on<LoadCustomFoodsEvent>((event, emit) async {
      emit(CustomFoodLoading());
      try {
        final foods = await getUseCase();
        emit(CustomFoodLoaded(foods: foods));
      } catch (e) {
        emit(CustomFoodError(message: e.toString()));
      }
    });

    on<AddCustomFoodEvent>((event, emit) async {
      try {
        await addUseCase(event.food);
        final foods = await getUseCase();
        emit(CustomFoodLoaded(foods: foods));
      } catch (e) {
        emit(CustomFoodError(message: e.toString()));
      }
    });

    on<DeleteCustomFoodEvent>((event, emit) async {
      try {
        await deleteUseCase(event.id);
        final foods = await getUseCase();
        emit(CustomFoodLoaded(foods: foods));
      } catch (e) {
        emit(CustomFoodError(message: e.toString()));
      }
    });
  }
}
