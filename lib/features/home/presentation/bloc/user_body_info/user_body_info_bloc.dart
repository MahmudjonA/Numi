import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numi/features/home/domain/use_cases/get_user_body_info_use_case.dart';
import 'package:numi/features/home/domain/use_cases/save_user_body_info_use_case.dart';

import '../../../domain/use_cases/calculate_daily_calories_use_case.dart';
import 'user_body_info_event.dart';
import 'user_body_info_state.dart';

class UserBodyInfoBloc extends Bloc<UserBodyInfoEvent, UserBodyInfoState> {
  final GetUserBodyInfoUseCase getUserBodyInfoUseCase;
  final SaveUserBodyInfoUseCase saveUserBodyInfoUseCase;
  final CalculateDailyCaloriesUseCase calculateDailyCaloriesUseCase;

  UserBodyInfoBloc(
    this.getUserBodyInfoUseCase,
    this.saveUserBodyInfoUseCase,
    this.calculateDailyCaloriesUseCase,
  ) : super(UserBodyInfoInitial()) {
    /// LOAD
    on<LoadUserBodyInfoEvent>((event, emit) async {
      emit(UserBodyInfoLoading());

      try {
        final info = await getUserBodyInfoUseCase();

        if (info == null) {
          emit(UserBodyInfoEmpty());
          return;
        }

        final calories = calculateDailyCaloriesUseCase(info);

        emit(UserBodyInfoLoaded(userBodyInfo: info, dailyCalories: calories));
      } catch (e) {
        emit(UserBodyInfoError(message: e.toString()));
      }
    });

    /// SAVE / UPDATE
    on<SaveUserBodyInfoEvent>((event, emit) async {
      emit(UserBodyInfoLoading());
      try {
        await saveUserBodyInfoUseCase(event.userBodyInfo);
        emit(
          UserBodyInfoLoaded(
            userBodyInfo: event.userBodyInfo,
            dailyCalories: calculateDailyCaloriesUseCase(event.userBodyInfo),
          ),
        );
      } catch (e) {
        emit(UserBodyInfoError(message: e.toString()));
      }
    });
  }
}
