import '../../models/weight_entry_model.dart';

abstract class WeightEntryLocalDataSource {
  Future<List<WeightEntryModel>> getAll();
  Future<void> add(WeightEntryModel entry);
  Future<void> delete(String id);
}
