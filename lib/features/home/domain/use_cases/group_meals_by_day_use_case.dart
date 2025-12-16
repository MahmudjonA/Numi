import '../entities/meal.dart';

class GroupMealsByDayUseCase {
  Map<DateTime, List<Meal>> call(List<Meal> meals) {
    final Map<DateTime, List<Meal>> result = {};

    for (final meal in meals) {
      final date = DateTime(
        meal.dateTime.year,
        meal.dateTime.month,
        meal.dateTime.day,
      );

      result.putIfAbsent(date, () => []);
      result[date]!.add(meal);
    }

    return result;
  }
}
