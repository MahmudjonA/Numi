import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:numi/core/constants/food_calories.dart';
import 'package:numi/core/l10n/app_strings.dart';
import 'package:numi/features/home/domain/entities/meal.dart';
import 'package:numi/features/home/presentation/bloc/meal/meal_bloc.dart';
import 'package:numi/features/home/presentation/bloc/meal/meal_event.dart';

class CategoryMealsPage extends StatefulWidget {
  final String categoryName;
  final List<String> images;

  const CategoryMealsPage({
    super.key,
    required this.categoryName,
    required this.images,
  });

  @override
  State<CategoryMealsPage> createState() => _CategoryMealsPageState();
}

class _CategoryMealsPageState extends State<CategoryMealsPage> {
  final Set<String> _addedIds = {};

  // Ovqat bosiganda meal type tanlash bottom sheet ko'rsatadi
  Future<void> _onFoodTap(BuildContext context, String imagePath) async {
    final rawName = imagePath.split('/').last.split('.').first;
    final info = getFoodInfo(rawName);
    final calories = info?.calories ?? 200;
    final displayName = rawName.replaceAll('_', ' ');

    // Meal type tanlash bottom sheet
    final MealType? chosen = await showModalBottomSheet<MealType>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _MealTypePicker(
        foodName: displayName,
        calories: calories,
        imagePath: imagePath,
      ),
    );

    if (chosen == null || !mounted) return;

    final meal = Meal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: rawName,
      calories: calories,
      category: widget.categoryName,
      dateTime: DateTime.now(),
      imagePath: imagePath,
      mealType: chosen,
      proteinG: info?.proteinG ?? 0.0,
      carbsG: info?.carbsG ?? 0.0,
      fatG: info?.fatG ?? 0.0,
    );

    context.read<MealBloc>().add(AddMealEvent(meal: meal));

    setState(() => _addedIds.add(imagePath));
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _addedIds.remove(imagePath));
    });

    final typeLabel = _mealTypeLabel(S.of(context), chosen);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 18),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                "$displayName ($typeLabel) — $calories kcal",
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF24AC8B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _mealTypeLabel(S s, MealType t) {
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
    final title = s.categoryName(widget.categoryName);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(title, style: Theme.of(context).textTheme.titleLarge),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded,
              color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: widget.images.isEmpty
          ? Center(
              child: Text(
                s.noFoodCategory,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
          : GridView.builder(
              padding: EdgeInsets.all(16.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: 0.9,
              ),
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                final imagePath = widget.images[index];
                final rawName =
                    imagePath.split('/').last.split('.').first;
                final displayName = rawName.replaceAll('_', ' ');
                final info = getFoodInfo(rawName);
                final calories = info?.calories ?? 200;
                final isAdded = _addedIds.contains(imagePath);

                return GestureDetector(
                  onTap: () => _onFoodTap(context, imagePath),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isAdded
                          ? const Color(0xFF24AC8B)
                          : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(18.r),
                      border: Border.all(
                        color: isAdded
                            ? const Color(0xFF24AC8B)
                            : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Colors.black.withValues(alpha: 0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: isAdded
                              ? Icon(
                                  Icons.check_circle_rounded,
                                  key: const ValueKey('check'),
                                  size: 52.h,
                                  color: Colors.white,
                                )
                              : Image.asset(
                                  imagePath,
                                  key: ValueKey(imagePath),
                                  height: 60.h,
                                  width: 60.w,
                                  errorBuilder: (_, __, ___) => Icon(
                                    Icons.fastfood_rounded,
                                    size: 48.h,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                  ),
                                ),
                        ),
                        SizedBox(height: 10.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Text(
                            displayName,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      isAdded ? Colors.white : null,
                                ),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            color: isAdded
                                ? Colors.white
                                    .withValues(alpha: 0.25)
                                : const Color(0xFF24AC8B)
                                    .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            "$calories kcal",
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                              color: isAdded
                                  ? Colors.white
                                  : const Color(0xFF24AC8B),
                            ),
                          ),
                        ),
                        if (info != null) ...[
                          SizedBox(height: 4.h),
                          Text(
                            "P:${info.proteinG.toStringAsFixed(0)}  C:${info.carbsG.toStringAsFixed(0)}  F:${info.fatG.toStringAsFixed(0)}",
                            style: TextStyle(
                              fontSize: 9.5.sp,
                              color: isAdded
                                  ? Colors.white70
                                  : Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.color,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// ── Meal Type tanlash bottom sheet ────────────────────────────────────────────
class _MealTypePicker extends StatelessWidget {
  final String foodName;
  final int calories;
  final String imagePath;

  const _MealTypePicker({
    required this.foodName,
    required this.calories,
    required this.imagePath,
  });

  List<_TypeOption> _buildTypes(S s) => [
    _TypeOption(type: MealType.Breakfast, label: s.breakfast, emoji: "🌅", time: s.breakfastTime, gradient: const [Color(0xFFFF9A3C), Color(0xFFFFCC02)]),
    _TypeOption(type: MealType.Lunch,     label: s.lunch,     emoji: "☀️", time: s.lunchTime,     gradient: const [Color(0xFF56AB2F), Color(0xFFA8E063)]),
    _TypeOption(type: MealType.Dinner,    label: s.dinner,    emoji: "🌙", time: s.dinnerTime,    gradient: const [Color(0xFF4776E6), Color(0xFF8E54E9)]),
    _TypeOption(type: MealType.Snack,     label: s.snack,     emoji: "🍎", time: s.anyTime,       gradient: const [Color(0xFFDA22FF), Color(0xFF9733EE)]),
  ];

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final types = _buildTypes(s);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 16.h),

          // Ovqat nomi + kaloriya
          Row(
            children: [
              // Rasm
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.asset(
                  imagePath,
                  width: 52.w,
                  height: 52.h,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 52.w,
                    height: 52.h,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.fastfood_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: 28,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      foodName,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      "$calories kcal",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF24AC8B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          Text(
            s.addToMeal,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6)),
          ),
          SizedBox(height: 14.h),

          // 2x2 Grid
          Row(
            children: [
              Expanded(child: _typeCard(context, types[0])),
              SizedBox(width: 10.w),
              Expanded(child: _typeCard(context, types[1])),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(child: _typeCard(context, types[2])),
              SizedBox(width: 10.w),
              Expanded(child: _typeCard(context, types[3])),
            ],
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  Widget _typeCard(BuildContext context, _TypeOption opt) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        Navigator.pop(context, opt.type);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: opt.gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: opt.gradient.first.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(opt.emoji, style: TextStyle(fontSize: 24.sp)),
            SizedBox(height: 8.h),
            Text(
              opt.label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              opt.time,
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeOption {
  final MealType type;
  final String label;
  final String emoji;
  final String time;
  final List<Color> gradient;

  const _TypeOption({
    required this.type,
    required this.label,
    required this.emoji,
    required this.time,
    required this.gradient,
  });
}
