import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:numi/core/constants/extensions/string_extensions.dart';
import '../../../../core/constants/extensions/mealImage.dart';
import '../../domain/entities/meal.dart';
import '../bloc/meal/meal_bloc.dart';
import '../bloc/meal/meal_event.dart';

class LastMealWg extends StatelessWidget {
  final List<Meal> meals;

  const LastMealWg({super.key, required this.meals});

  @override
  Widget build(BuildContext context) {
    if (meals.isEmpty) {
      return Center(
        child: Text(
          "No meals yet",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    final int totalCalories = meals.fold(0, (sum, meal) => sum + meal.calories);
    final DateTime date = meals.first.dateTime;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Consumed",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const Spacer(),
              Text(
                "$totalCalories kcal",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),

          SizedBox(height: 4.h),

          Text(
            formatDate(date),
            style: Theme.of(context).textTheme.labelMedium,
          ),

          SizedBox(height: 12.h),

          Column(
            children: meals.map((meal) {
              return Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.all(12.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Row(
                  children: [
                    mealImage(meal),

                    SizedBox(width: 12.w),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meal.name.capitalize().replaceAll("_", " "),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.surface,
                              ),
                        ),

                        Text(
                          "${meal.calories} kcal",
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.surface,
                              ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).colorScheme.surface,
                      ),

                      onPressed: () {
                        context.read<MealBloc>().add(
                          DeleteMealEvent(id: meal.id),
                        );
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

String formatDate(DateTime date) {
  return "${date.day}/${date.month}/${date.year}";
}
