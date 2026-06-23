abstract class WeightEvent {
  const WeightEvent();
}

class LoadWeightHistoryEvent extends WeightEvent {}

class AddWeightEntryEvent extends WeightEvent {
  final double weightKg;
  final String? note;
  final DateTime dateTime;

  const AddWeightEntryEvent({
    required this.weightKg,
    required this.dateTime,
    this.note,
  });
}

class DeleteWeightEntryEvent extends WeightEvent {
  final String id;
  const DeleteWeightEntryEvent({required this.id});
}
