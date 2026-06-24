import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:numi/core/l10n/app_strings.dart';
import 'package:numi/core/widgets/padding_wg.dart';
import 'package:numi/features/home/presentation/pages/add_meal_manual_page.dart';
import 'package:numi/features/home/presentation/pages/daily_calories_page.dart';
import 'package:numi/features/home/presentation/widgets/app_bar_wg.dart';
import 'package:numi/features/home/presentation/widgets/banners_wg.dart';
import 'package:numi/features/home/presentation/widgets/categories_wg.dart';
import 'package:numi/features/home/presentation/widgets/last_meal_wg.dart';
import 'package:numi/features/home/presentation/widgets/water_widget.dart';
import 'package:numi/features/home/presentation/widgets/weight_mini_widget.dart';
import '../../domain/use_cases/group_meals_by_day_use_case.dart';
import '../bloc/meal/meal_bloc.dart';
import '../bloc/meal/meal_state.dart';
import '../widgets/daily_calories_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBarWg(),
      ),
      body: PaddingWg(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Kunlik kaloriya ─────────────────────────
            DailyCaloriesCard(
              onPress: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DailyCaloriesPage()),
              ),
            ),
            SizedBox(height: 12.h),

            // ── Vazn + Suv yan-yonida ──────────────────
            const WeightMiniWidget(),
            SizedBox(height: 10.h),
            const WaterWidget(),
            SizedBox(height: 16.h),

            // ── Banner ─────────────────────────────────
            const BannersWg(),
            SizedBox(height: 16.h),

            // ── Kategoriyalar ──────────────────────────
            _SectionHeader(
              title: S.of(context).categories,
              trailing: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddMealManualPage(initSaveToLibrary: true),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_rounded,
                          size: 14.sp,
                          color: Theme.of(context).colorScheme.primary),
                      SizedBox(width: 4.w),
                      Text(
                        S.of(context).addToCategory,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            const CategoriesWg(),
            SizedBox(height: 20.h),

            // ── Bugungi ovqatlar ──────────────────────
            _SectionHeader(
              title: S.of(context).todayMeals,
              trailing: BlocBuilder<MealBloc, MealState>(
                builder: (context, state) {
                  if (state is MealLoaded) {
                    final grouped = GroupMealsByDayUseCase()(state.meals);
                    final today = DateTime.now();
                    final key = DateTime(today.year, today.month, today.day);
                    final count = (grouped[key] ?? []).length;
                    if (count > 0) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          "$count ta",
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      );
                    }
                  }
                  return const SizedBox();
                },
              ),
            ),
            SizedBox(height: 10.h),
            BlocBuilder<MealBloc, MealState>(
              builder: (context, state) {
                if (state is MealLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  );
                }
                if (state is MealLoaded) {
                  final grouped = GroupMealsByDayUseCase()(state.meals);
                  final today = DateTime.now();
                  final key = DateTime(today.year, today.month, today.day);
                  return LastMealWg(meals: grouped[key] ?? []);
                }
                return const SizedBox();
              },
            ),
            SizedBox(height: 100.h),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  const _SectionHeader({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const Spacer(),
        if (trailing != null) trailing!,
      ],
    );
  }
}
