import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:numi/core/constants/extensions/string_extensions.dart';
import 'package:numi/core/l10n/app_strings.dart';
import '../../../../core/constants/extensions/mealImage.dart';
import '../../domain/entities/meal.dart';
import '../bloc/meal/meal_bloc.dart';
import '../bloc/meal/meal_event.dart';

const _typeColors = {
  MealType.Breakfast: Color(0xFFFF9A3C),
  MealType.Lunch:     Color(0xFF56AB2F),
  MealType.Dinner:    Color(0xFF4776E6),
  MealType.Snack:     Color(0xFFDA22FF),
};

const _typeEmojis = {
  MealType.Breakfast: '🌅',
  MealType.Lunch:     '☀️',
  MealType.Dinner:    '🌙',
  MealType.Snack:     '🍎',
};

class LastMealWg extends StatelessWidget {
  final List<Meal> meals;

  const LastMealWg({super.key, required this.meals});

  String _typeLabel(S s, MealType t) {
    switch (t) {
      case MealType.Breakfast: return s.breakfast;
      case MealType.Lunch:     return s.lunch;
      case MealType.Dinner:    return s.dinner;
      case MealType.Snack:     return s.snack;
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    if (meals.isEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.no_meals_rounded,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.25),
              size: 22,
            ),
            SizedBox(width: 8.w),
            Text(
              s.noMealsYet,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.4),
                  ),
            ),
          ],
        ),
      );
    }

    final Map<MealType, List<Meal>> grouped = {};
    for (final order in MealType.values) {
      final group = meals.where((m) => m.mealType == order).toList();
      if (group.isNotEmpty) grouped[order] = group;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: grouped.entries.map((entry) {
        final type = entry.key;
        final typeMeals = entry.value;
        final groupTotal = typeMeals.fold(0, (acc, m) => acc + m.calories);

        return _MealGroup(
          label: _typeLabel(s, type),
          emoji: _typeEmojis[type]!,
          color: _typeColors[type]!,
          countLabel: s.mealsCount(typeMeals.length),
          meals: typeMeals,
          total: groupTotal,
        );
      }).toList(),
    );
  }
}

// ── Bir guruh (masalan Nonushta) ─────────────────────────────────────────────
class _MealGroup extends StatelessWidget {
  final String label;
  final String emoji;
  final Color color;
  final String countLabel;
  final List<Meal> meals;
  final int total;

  const _MealGroup({
    required this.label,
    required this.emoji,
    required this.color,
    required this.countLabel,
    required this.meals,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
            ),
            child: Row(
              children: [
                Container(
                  width: 34.w,
                  height: 34.h,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: Text(emoji, style: TextStyle(fontSize: 16.sp)),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                      ),
                      Text(
                        countLabel,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: color.withValues(alpha: 0.7),
                            ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    "$total kcal",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 10.h),
            child: Column(
              children: meals
                  .map((meal) => _MealCard(meal: meal, typeColor: color))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Yakka ovqat kartasi ───────────────────────────────────────────────────────
class _MealCard extends StatelessWidget {
  final Meal meal;
  final Color typeColor;

  const _MealCard({required this.meal, required this.typeColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          // Rasm
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: typeColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(child: mealImage(meal)),
          ),
          SizedBox(width: 10.w),

          // Nom + makrolar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.name.capitalize().replaceAll("_", " "),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (meal.proteinG > 0)
                  Text(
                    "P:${meal.proteinG.toStringAsFixed(0)}  C:${meal.carbsG.toStringAsFixed(0)}  F:${meal.fatG.toStringAsFixed(0)}",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.4),
                          fontSize: 9.sp,
                        ),
                  ),
              ],
            ),
          ),

          // Kaloriya
          Text(
            "${meal.calories} kcal",
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: typeColor,
            ),
          ),
          SizedBox(width: 6.w),

          // O'chirish
          GestureDetector(
            onTap: () => context
                .read<MealBloc>()
                .add(DeleteMealEvent(id: meal.id)),
            child: Icon(
              Icons.delete_outline_rounded,
              size: 18,
              color: Colors.red.withValues(alpha: 0.55),
            ),
          ),
        ],
      ),
    );
  }
}
