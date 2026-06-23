import 'package:hive/hive.dart';
import '../../models/weight_entry_model.dart';
import 'weight_entry_local_data_source.dart';

class WeightEntryLocalDataSourceImpl implements WeightEntryLocalDataSource {
  static const String _boxName = 'weight_entries';

  Box<WeightEntryModel> get _box => Hive.box<WeightEntryModel>(_boxName);

  @override
  Future<List<WeightEntryModel>> getAll() async {
    final list = _box.values.toList();
    list.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return list;
  }

  @override
  Future<void> add(WeightEntryModel entry) async {
    await _box.put(entry.id, entry);
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }
}
