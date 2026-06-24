import 'package:flutter/material.dart';
import '../../../features/home/domain/entities/meal.dart';

Widget mealImage(Meal meal) {
  if (meal.imagePath != null) {
    return Image.asset(
      meal.imagePath!,
      width: 40,
      height: 40,
      errorBuilder: (_, __, ___) => const Icon(
        Icons.restaurant_rounded,
        size: 24,
        color: Color(0xFF24AC8B),
      ),
    );
  }
  return const Icon(
    Icons.restaurant_rounded,
    size: 24,
    color: Color(0xFF24AC8B),
  );
}
