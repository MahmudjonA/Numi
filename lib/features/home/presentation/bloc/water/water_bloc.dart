import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/water_intake_repo.dart';
import 'water_event.dart';
import 'water_state.dart';

class WaterBloc extends Bloc<WaterEvent, WaterState> {
  final WaterIntakeRepo repo;
  static const int _goalMl = 2000;

  WaterBloc(this.repo) : super(WaterInitial()) {
    on<LoadWaterEvent>((event, emit) async {
      final intake = await repo.getTodayIntake();
      emit(WaterLoaded(totalMl: intake?.totalMl ?? 0, goalMl: _goalMl));
    });

    on<AddWaterEvent>((event, emit) async {
      await repo.addWater(event.ml);
      final intake = await repo.getTodayIntake();
      emit(WaterLoaded(totalMl: intake?.totalMl ?? 0, goalMl: _goalMl));
    });

    on<ResetWaterEvent>((event, emit) async {
      await repo.resetToday();
      emit(WaterLoaded(totalMl: 0, goalMl: _goalMl));
    });
  }
}
