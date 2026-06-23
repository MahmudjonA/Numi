import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:numi/core/l10n/app_strings.dart';
import 'package:numi/features/home/presentation/bloc/meal/meal_bloc.dart';
import 'package:numi/features/home/presentation/bloc/meal/meal_state.dart';
import 'package:numi/features/home/presentation/bloc/user_body_info/user_body_info_bloc.dart';
import 'package:numi/features/home/presentation/bloc/user_body_info/user_body_info_state.dart';
import 'package:numi/features/home/presentation/pages/weight_history_page.dart';
class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).statsTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        bottom: TabBar(
          controller: _tab,
          indicatorColor: Theme.of(context).colorScheme.primary,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor:
              Theme.of(context).iconTheme.color?.withValues(alpha: 0.5),
          tabs: [
            Tab(text: S.of(context).caloriesTab),
            Tab(text: S.of(context).weightTab),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          const _CalorieStatsTab(),
          const WeightHistoryPage(),
        ],
      ),
    );
  }
}

// ── Kaloriya statistikasi ──────────────────────────────────────
class _CalorieStatsTab extends StatefulWidget {
  const _CalorieStatsTab();

  @override
  State<_CalorieStatsTab> createState() => _CalorieStatsTabState();
}

class _CalorieStatsTabState extends State<_CalorieStatsTab> {
  bool _thisWeek = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBodyInfoBloc, UserBodyInfoState>(
      builder: (context, bodyState) {
        final goal = bodyState is UserBodyInfoLoaded
            ? bodyState.dailyCalories.toDouble()
            : 2000.0;

        return BlocBuilder<MealBloc, MealState>(
          builder: (context, mealState) {
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);

            final offset = _thisWeek ? 0 : 7;
            final days = List.generate(7, (i) {
              return today.subtract(Duration(days: 6 - i + offset));
            });

            Map<DateTime, int> kcalByDay = {};
            Map<DateTime, double> proteinByDay = {};
            Map<DateTime, double> carbsByDay = {};
            Map<DateTime, double> fatByDay = {};

            if (mealState is MealLoaded) {
              for (final meal in mealState.meals) {
                final key = DateTime(
                    meal.dateTime.year,
                    meal.dateTime.month,
                    meal.dateTime.day);
                kcalByDay[key] = (kcalByDay[key] ?? 0) + meal.calories;
                proteinByDay[key] =
                    (proteinByDay[key] ?? 0) + meal.proteinG;
                carbsByDay[key] =
                    (carbsByDay[key] ?? 0) + meal.carbsG;
                fatByDay[key] = (fatByDay[key] ?? 0) + meal.fatG;
              }
            }

            final totalKcal = days.fold(
                0, (s, d) => s + (kcalByDay[d] ?? 0));
            final avgKcal =
                totalKcal > 0 ? totalKcal / days.length : 0;

            // TabBarView bounded height beradi — PaddingWg(SingleChildScrollView) + ListView
            // ikki qavatli scroll bo'ladi. To'g'ridan-to'g'ri ListView ishlatamiz.
            return ListView(
              padding: EdgeInsets.all(16.w),
              children: [
                // ── Toggle ──────────────────────────────
                  Row(
                    children: [
                      _toggle(S.of(context).thisWeek, true),
                      SizedBox(width: 8.w),
                      _toggle(S.of(context).lastWeek, false),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // ── Bar Chart ───────────────────────────
                  Container(
                    height: 200.h,
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: BarChart(
                      BarChartData(
                        maxY: goal * 1.3,
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: const AxisTitles(
                              sideTitles:
                                  SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(
                              sideTitles:
                                  SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(
                              sideTitles:
                                  SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (v, _) {
                                final idx = v.toInt();
                                if (idx < 0 || idx >= days.length) {
                                  return const SizedBox();
                                }
                                final d = days[idx];
                                final names = S.of(context).weekDays;
                                return Text(
                                  names[d.weekday - 1],
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall,
                                );
                              },
                            ),
                          ),
                        ),
                        barGroups: days.asMap().entries.map((e) {
                          final idx = e.key;
                          final day = e.value;
                          final kcal =
                              (kcalByDay[day] ?? 0).toDouble();
                          final ratio = goal > 0 ? kcal / goal : 0.0;
                          final barColor = ratio < 0.6
                              ? Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.5)
                              : ratio <= 1.0
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.red;

                          return BarChartGroupData(
                            x: idx,
                            barRods: [
                              BarChartRodData(
                                toY: kcal,
                                color: barColor,
                                width: 20.w,
                                borderRadius:
                                    BorderRadius.circular(4.r),
                                backDrawRodData:
                                    BackgroundBarChartRodData(
                                  show: true,
                                  toY: goal,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withValues(alpha: 0.08),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // ── Summary cards ────────────────────────
                  Row(
                    children: [
                      _statCard(S.of(context).totalWeek, "$totalKcal kcal", context),
                      SizedBox(width: 8.w),
                      _statCard(S.of(context).avgDay, "${avgKcal.toStringAsFixed(0)} kcal", context),
                      SizedBox(width: 8.w),
                      _statCard(S.of(context).goalDay, "${goal.toStringAsFixed(0)} kcal", context),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // ── Makrolar haftalik ────────────────────
                  Text(
                    S.of(context).weeklyMacros,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 10.h),
                  ...days.map((day) {
                    final p = proteinByDay[day] ?? 0;
                    final c = carbsByDay[day] ?? 0;
                    final f = fatByDay[day] ?? 0;
                    final k = kcalByDay[day] ?? 0;
                    if (k == 0) return const SizedBox();
                    return Container(
                      margin: EdgeInsets.only(bottom: 8.h),
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 48.w,
                            child: Text(
                              "${day.day}/${day.month}",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "$k kcal  •  P:${p.toStringAsFixed(0)}g  C:${c.toStringAsFixed(0)}g  F:${f.toStringAsFixed(0)}g",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            );
          },
        );
      },
    );
  }

  Widget _toggle(String label, bool isThisWeek) {
    final selected = _thisWeek == isThisWeek;
    return GestureDetector(
      onTap: () => setState(() => _thisWeek = isThisWeek),
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: selected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: selected
                    ? Theme.of(context).colorScheme.onPrimary
                    : null,
                fontWeight: selected ? FontWeight.bold : null,
              ),
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: Theme.of(context).textTheme.labelSmall),
            SizedBox(height: 4.h),
            Text(
              value,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
