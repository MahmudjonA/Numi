import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/user_body_repo.dart';
import '../../../domain/repositories/water_intake_repo.dart';
import 'water_event.dart';
import 'water_state.dart';

class WaterBloc extends Bloc<WaterEvent, WaterState> {
  final WaterIntakeRepo repo;
  final UserBodyRepo bodyRepo;

  static const int _defaultGoalMl = 2000;

  WaterBloc(this.repo, this.bodyRepo) : super(WaterInitial()) {
    on<LoadWaterEvent>((event, emit) async {
      final intake = await repo.getTodayIntake();
      final goal   = await _calcGoal();
      emit(WaterLoaded(totalMl: intake?.totalMl ?? 0, goalMl: goal));
    });

    on<AddWaterEvent>((event, emit) async {
      await repo.addWater(event.ml);
      final intake = await repo.getTodayIntake();
      final goal   = await _calcGoal();
      emit(WaterLoaded(totalMl: intake?.totalMl ?? 0, goalMl: goal));
    });

    on<ResetWaterEvent>((event, emit) async {
      await repo.resetToday();
      final goal = await _calcGoal();
      emit(WaterLoaded(totalMl: 0, goalMl: goal));
    });
  }

  /// weight (kg) × 35 ml, 50ml ga yaxlitlangan. Default 2000ml.
  Future<int> _calcGoal() async {
    try {
      final info = await bodyRepo.getUserBodyInfo();
      if (info == null) return _defaultGoalMl;
      final raw = (info.weightKg * 35).round();
      return ((raw / 50).round() * 50).clamp(1000, 5000);
    } catch (_) {
      return _defaultGoalMl;
    }
  }
}
