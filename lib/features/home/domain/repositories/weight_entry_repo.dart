import '../entities/weight_entry.dart';

abstract class WeightEntryRepo {
  Future<List<WeightEntry>> getAll();
  Future<void> add(WeightEntry entry);
  Future<void> delete(String id);
}
