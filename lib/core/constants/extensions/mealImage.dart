import 'package:flutter/material.dart';
import '../../../features/home/domain/entities/meal.dart';

Widget mealImage(Meal meal) {
  if (meal.imagePath != null) {
    return Image.asset(
      meal.imagePath!,
      width: 40,
      height: 40,
    );
  }

  return const Icon(
    Icons.camera_alt,
    color: Colors.black,
    size: 40,
  );
}
