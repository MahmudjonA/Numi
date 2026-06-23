import '../entities/weight_entry.dart';
import '../repositories/weight_entry_repo.dart';

class GetWeightHistoryUseCase {
  final WeightEntryRepo repo;
  GetWeightHistoryUseCase(this.repo);

  Future<List<WeightEntry>> call({int days = 7}) async {
    final all = await repo.getAll();
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return all.where((e) => e.dateTime.isAfter(cutoff)).toList();
  }
}
