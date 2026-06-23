import 'package:hive/hive.dart';
import '../../models/water_intake_model.dart';
import 'water_intake_local_data_source.dart';

class WaterIntakeLocalDataSourceImpl implements WaterIntakeLocalDataSource {
  static const String _boxName = 'water_intake';

  Box<WaterIntakeModel> get _box => Hive.box<WaterIntakeModel>(_boxName);

  @override
  Future<WaterIntakeModel?> getByDateKey(String dateKey) async {
    return _box.get(dateKey);
  }

  @override
  Future<void> save(WaterIntakeModel model) async {
    await _box.put(model.dateKey, model);
  }
}
