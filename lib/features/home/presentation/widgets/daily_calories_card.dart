import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:numi/core/l10n/app_strings.dart';
import '../bloc/meal/meal_bloc.dart';
import '../bloc/meal/meal_state.dart';
import '../bloc/user_body_info/user_body_info_bloc.dart';
import '../bloc/user_body_info/user_body_info_state.dart';
import '../../domain/use_cases/group_meals_by_day_use_case.dart';

class DailyCaloriesCard extends StatelessWidget {
  final VoidCallback onPress;

  const DailyCaloriesCard({super.key, required this.onPress});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BlocBuilder<UserBodyInfoBloc, UserBodyInfoState>(
      builder: (context, bodyState) {
        return BlocBuilder<MealBloc, MealState>(
          builder: (context, mealState) {
            final goalKcal =
                bodyState is UserBodyInfoLoaded ? bodyState.dailyCalories : 0;

            int consumedKcal = 0;
            double protein = 0, carbs = 0, fat = 0;

            if (mealState is MealLoaded) {
              final grouped = GroupMealsByDayUseCase()(mealState.meals);
              final today = DateTime.now();
              final key = DateTime(today.year, today.month, today.day);
              final todayMeals = grouped[key] ?? [];
              consumedKcal = todayMeals.fold(0, (s, m) => s + m.calories);
              protein = todayMeals.fold(0.0, (s, m) => s + m.proteinG);
              carbs   = todayMeals.fold(0.0, (s, m) => s + m.carbsG);
              fat     = todayMeals.fold(0.0, (s, m) => s + m.fatG);
            }

            final progress = goalKcal > 0
                ? (consumedKcal / goalKcal).clamp(0.0, 1.0)
                : 0.0;
            final remaining = goalKcal > 0
                ? (goalKcal - consumedKcal).clamp(0, goalKcal)
                : 0;
            final Color barColor = progress < 0.6
                ? const Color(0xFF24AC8B)
                : progress < 0.9
                    ? Colors.orange
                    : Colors.red;

            return Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16.r),
                onTap: onPress,
                child: Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Header ──────────────────────────
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  s.dailyCaloriesCard,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withValues(alpha: 0.55),
                                      ),
                                ),
                                SizedBox(height: 2.h),
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      "$consumedKcal",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                            color: barColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Text(
                                      " / $goalKcal kcal",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                              color: barColor
                                                  .withValues(alpha: 0.7)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Icon(Icons.local_fire_department,
                                  color: barColor, size: 22),
                              SizedBox(height: 4.h),
                              Text(
                                goalKcal > 0
                                    ? s.kcalLeft(remaining)
                                    : s.noGoalLabel,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(color: barColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),

                      // ── Progress bar ────────────────────
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 8.h,
                          backgroundColor:
                              barColor.withValues(alpha: 0.15),
                          valueColor:
                              AlwaysStoppedAnimation<Color>(barColor),
                        ),
                      ),
                      SizedBox(height: 14.h),

                      // ── Makrolar ─────────────────────────
                      Row(
                        children: [
                          _MacroBar(
                            label: "Protein",
                            value: protein,
                            goal: 50,
                            color: Colors.blue,
                          ),
                          SizedBox(width: 8.w),
                          _MacroBar(
                            label: "Carbs",
                            value: carbs,
                            goal: 250,
                            color: Colors.orange,
                          ),
                          SizedBox(width: 8.w),
                          _MacroBar(
                            label: "Fat",
                            value: fat,
                            goal: 65,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _MacroBar extends StatelessWidget {
  final String label;
  final double value;
  final double goal;
  final Color  color;

  const _MacroBar({
    required this.label,
    required this.value,
    required this.goal,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (value / goal).clamp(0.0, 1.0);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                    ),
              ),
              Text(
                "${value.toStringAsFixed(0)}g",
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6.h,
              backgroundColor: color.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}
