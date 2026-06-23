import '../../domain/entities/water_intake.dart';
import '../../domain/repositories/water_intake_repo.dart';
import '../data_sources/local/water_intake_local_data_source.dart';
import '../models/water_intake_model.dart';

class WaterIntakeRepositoryImpl implements WaterIntakeRepo {
  final WaterIntakeLocalDataSource dataSource;

  WaterIntakeRepositoryImpl(this.dataSource);

  String get _todayKey => WaterIntake.keyFromDate(DateTime.now());

  @override
  Future<WaterIntake?> getTodayIntake() async {
    final model = await dataSource.getByDateKey(_todayKey);
    return model?.toEntity();
  }

  @override
  Future<void> addWater(int ml) async {
    final existing = await dataSource.getByDateKey(_todayKey);
    final newTotal = (existing?.totalMl ?? 0) + ml;
    await dataSource.save(
      WaterIntakeModel(dateKey: _todayKey, totalMl: newTotal),
    );
  }

  @override
  Future<void> resetToday() async {
    await dataSource.save(
      WaterIntakeModel(dateKey: _todayKey, totalMl: 0),
    );
  }
}
