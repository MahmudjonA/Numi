import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:numi/core/l10n/app_strings.dart';
import 'package:numi/features/home/domain/entities/meal.dart';
import 'package:numi/features/home/presentation/pages/my_foods_page.dart';
import 'package:numi/features/home/presentation/widgets/last_meal_wg.dart';
import '../../domain/use_cases/group_meals_by_day_use_case.dart';
import '../bloc/meal/meal_bloc.dart';
import '../bloc/meal/meal_state.dart';
import 'add_meal_manual_page.dart';

class MealPage extends StatefulWidget {
  const MealPage({super.key});

  @override
  State<MealPage> createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
  MealType? _filterType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(S.of(context).mealHistoryTitle,
            style: Theme.of(context).textTheme.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.book_outlined),
            tooltip: S.of(context).myFoodsTitle,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MyFoodsPage()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: S.of(context).addManualBtn,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddMealManualPage()),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<MealBloc, MealState>(
          builder: (context, state) {
            if (state is MealLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              );
            }

            if (state is MealLoaded) {
              final filtered = _filterType == null
                  ? state.meals
                  : state.meals
                      .where((m) => m.mealType == _filterType)
                      .toList();

              final grouped = GroupMealsByDayUseCase()(filtered);
              final sortedKeys = grouped.keys.toList()
                ..sort((a, b) => b.compareTo(a));
              final limitedKeys = sortedKeys.take(30).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Filter chips ─────────────────────────
                  SizedBox(
                    height: 44.h,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 6.h),
                      children: [
                        _buildFilterChip(S.of(context).all, null),
                        ...MealType.values
                            .map((t) => _buildFilterChip(_typeLabel(S.of(context), t), t)),
                      ],
                    ),
                  ),

                  // ── Ro'yxat ──────────────────────────────
                  Expanded(
                    child: limitedKeys.isEmpty
                        ? _EmptyState()
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 8.h),
                            itemCount: limitedKeys.length,
                            itemBuilder: (_, i) {
                              final key = limitedKeys[i];
                              final meals = grouped[key]!;
                              return _DayBlock(date: key, meals: meals);
                            },
                          ),
                  ),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, MealType? type) {
    final selected = _filterType == type;
    return GestureDetector(
      onTap: () => setState(() => _filterType = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(right: 8.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: selected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: selected
                    ? Theme.of(context).colorScheme.onPrimary
                    : null,
                fontWeight:
                    selected ? FontWeight.bold : FontWeight.normal,
              ),
        ),
      ),
    );
  }

  String _typeLabel(S s, MealType t) {
    switch (t) {
      case MealType.Breakfast: return s.breakfast;
      case MealType.Lunch:     return s.lunch;
      case MealType.Dinner:    return s.dinner;
      case MealType.Snack:     return s.snack;
    }
  }
}

// ── Kun bloki ─────────────────────────────────────────────────
class _DayBlock extends StatefulWidget {
  final DateTime date;
  final List<Meal> meals;
  const _DayBlock({required this.date, required this.meals});

  @override
  State<_DayBlock> createState() => _DayBlockState();
}

class _DayBlockState extends State<_DayBlock> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final total = widget.meals.fold(0, (s, m) => s + m.calories);
    final protein = widget.meals.fold(0.0, (s, m) => s + m.proteinG);
    final carbs = widget.meals.fold(0.0, (s, m) => s + m.carbsG);
    final fat = widget.meals.fold(0.0, (s, m) => s + m.fatG);

    final today = DateTime.now();
    final todayKey = DateTime(today.year, today.month, today.day);
    final d = widget.date;
    final s = S.of(context);
    final label = d == todayKey
        ? s.today
        : d == todayKey.subtract(const Duration(days: 1))
            ? s.yesterday
            : "${d.day}/${d.month}/${d.year}";

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
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
          // Header
          InkWell(
            borderRadius: BorderRadius.circular(18.r),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: EdgeInsets.all(14.r),
              child: Row(
                children: [
                  Container(
                    width: 42.w,
                    height: 42.h,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${d.day}",
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Text(
                          _monthShort(d.month),
                          style: TextStyle(
                            fontSize: 9.sp,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "$total kcal  •  ${widget.meals.length} ta ovqat",
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary,
                              ),
                        ),
                        Text(
                          "P:${protein.toStringAsFixed(0)}g  C:${carbs.toStringAsFixed(0)}g  F:${fat.toStringAsFixed(0)}g",
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.45),
                              ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),

          // Ovqatlar ro'yxati
          if (_expanded)
            Padding(
              padding:
                  EdgeInsets.only(left: 14.w, right: 14.w, bottom: 14.h),
              child: LastMealWg(meals: widget.meals),
            ),
        ],
      ),
    );
  }

  String _monthShort(int m) {
    const months = [
      'Yan','Feb','Mar','Apr','May','Iyn',
      'Iyl','Avg','Sen','Okt','Noy','Dec'
    ];
    return months[m - 1];
  }
}

// ── Bo'sh holat ───────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.restaurant_menu_rounded,
            size: 64,
            color: Theme.of(context)
                .colorScheme
                .primary
                .withValues(alpha: 0.3),
          ),
          SizedBox(height: 16.h),
          Text(
            "Hali ovqat qo'shilmagan",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.5),
                ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Kamera yoki + tugmasini bosing",
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.35),
                ),
          ),
        ],
      ),
    );
  }
}
