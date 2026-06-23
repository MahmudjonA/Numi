class WaterIntake {
  final String dateKey; // "2026-06-23"
  final int totalMl;

  const WaterIntake({required this.dateKey, required this.totalMl});

  static String keyFromDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
