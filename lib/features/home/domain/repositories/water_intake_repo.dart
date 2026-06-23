import '../entities/water_intake.dart';

abstract class WaterIntakeRepo {
  Future<WaterIntake?> getTodayIntake();
  Future<void> addWater(int ml);
  Future<void> resetToday();
}
