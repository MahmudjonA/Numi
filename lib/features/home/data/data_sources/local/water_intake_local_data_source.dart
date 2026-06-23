import '../../models/water_intake_model.dart';

abstract class WaterIntakeLocalDataSource {
  Future<WaterIntakeModel?> getByDateKey(String dateKey);
  Future<void> save(WaterIntakeModel model);
}
