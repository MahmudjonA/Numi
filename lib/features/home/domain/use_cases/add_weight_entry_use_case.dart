import '../entities/weight_entry.dart';
import '../repositories/weight_entry_repo.dart';

class AddWeightEntryUseCase {
  final WeightEntryRepo repo;
  AddWeightEntryUseCase(this.repo);
  Future<void> call(WeightEntry entry) => repo.add(entry);
}
