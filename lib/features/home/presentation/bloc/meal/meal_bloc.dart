import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numi/features/home/domain/use_cases/add_meal_use_case.dart';
import 'package:numi/features/home/domain/use_cases/delete_meal_use_case.dart';
import 'package:numi/features/home/domain/use_cases/get_meal_use_case.dart';
import 'meal_event.dart';
import 'meal_state.dart';

class MealBloc extends Bloc<MealEvent, MealState> {
  final AddMealUseCase addMealUseCase;
  final DeleteMealUseCase deleteMealUseCase;
  final GetMealsUseCase getMealsUseCase;

  MealBloc(
      this.addMealUseCase,
      this.deleteMealUseCase,
      this.getMealsUseCase,
      ) : super(MealInitial()) {

    /// LOAD
    on<LoadMealsEvent>((event, emit) async {
      emit(MealLoading());
      try {
        final meals = await getMealsUseCase();
        emit(MealLoaded(meals: meals));
      } catch (e) {
        emit(MealError(message: e.toString()));
      }
    });

    /// ADD
    on<AddMealEvent>((event, emit) async {
      try {
        await addMealUseCase(event.meal);
        final meals = await getMealsUseCase();
        emit(MealLoaded(meals: meals));
      } catch (e) {
        emit(MealError(message: e.toString()));
      }
    });

    /// DELETE
    on<DeleteMealEvent>((event, emit) async {
      try {
        await deleteMealUseCase(event.id);
        final meals = await getMealsUseCase();
        emit(MealLoaded(meals: meals));
      } catch (e) {
        emit(MealError(message: e.toString()));
      }
    });
  }
}
