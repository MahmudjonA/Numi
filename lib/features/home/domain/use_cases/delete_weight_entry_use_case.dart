import '../repositories/weight_entry_repo.dart';

class DeleteWeightEntryUseCase {
  final WeightEntryRepo repo;
  DeleteWeightEntryUseCase(this.repo);
  Future<void> call(String id) => repo.delete(id);
}
