class CustomFood {
  final String id;
  final String name;
  final int calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final String? category;

  const CustomFood({
    required this.id,
    required this.name,
    required this.calories,
    this.proteinG = 0.0,
    this.carbsG = 0.0,
    this.fatG = 0.0,
    this.category,
  });
}
