enum Gender {
  male,
  female,
}

enum ActivityLevel {
  sedentary,
  light,
  moderate,
  active,
  veryActive,
}

class UserBodyInfo {
  final double weightKg;
  final double heightCm;
  final int age;
  final Gender gender;
  final ActivityLevel activityLevel;

  const UserBodyInfo({
    required this.weightKg,
    required this.heightCm,
    required this.age,
    required this.gender,
    required this.activityLevel,
  });
}
