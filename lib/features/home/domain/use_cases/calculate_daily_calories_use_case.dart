import 'package:numi/features/home/domain/entities/user_body_info.dart';

class CalculateDailyCaloriesUseCase {
  int call(UserBodyInfo info) {
    final bmr = _calculateBmr(info);
    final multiplier = _activityMultiplier(info.activityLevel);

    return (bmr * multiplier).round();
  }

  double _calculateBmr(UserBodyInfo info) {
    final base =
        (10 * info.weightKg) +
            (6.25 * info.heightCm) -
            (5 * info.age);

    return info.gender == Gender.Male
        ? base + 5
        : base - 161;
  }

  double _activityMultiplier(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.Sedentary:
        return 1.2;
      case ActivityLevel.Light:
        return 1.375;
      case ActivityLevel.Moderate:
        return 1.55;
      case ActivityLevel.Active:
        return 1.725;
      case ActivityLevel.VeryActive:
        return 1.9;
    }
  }
}
