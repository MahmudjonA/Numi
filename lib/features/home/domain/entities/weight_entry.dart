class WeightEntry {
  final String id;
  final double weightKg;
  final DateTime dateTime;
  final String? note;

  const WeightEntry({
    required this.id,
    required this.weightKg,
    required this.dateTime,
    this.note,
  });
}
