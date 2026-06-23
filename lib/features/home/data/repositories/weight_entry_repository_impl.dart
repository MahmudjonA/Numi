import '../../domain/entities/weight_entry.dart';
import '../../domain/repositories/weight_entry_repo.dart';
import '../data_sources/local/weight_entry_local_data_source.dart';
import '../models/weight_entry_model.dart';

class WeightEntryRepositoryImpl implements WeightEntryRepo {
  final WeightEntryLocalDataSource dataSource;

  WeightEntryRepositoryImpl(this.dataSource);

  @override
  Future<List<WeightEntry>> getAll() async {
    final models = await dataSource.getAll();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> add(WeightEntry entry) async {
    await dataSource.add(WeightEntryModel.fromEntity(entry));
  }

  @override
  Future<void> delete(String id) async {
    await dataSource.delete(id);
  }
}
