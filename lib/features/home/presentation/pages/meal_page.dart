import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numi/core/app_colors.dart';
import 'package:numi/core/widgets/padding_wg.dart';
import 'package:numi/features/home/presentation/widgets/last_meal_wg.dart';
import '../../domain/use_cases/group_meals_by_day_use_case.dart';
import '../bloc/meal/meal_bloc.dart';
import '../bloc/meal/meal_state.dart';

class MealPage extends StatelessWidget {
  const MealPage({super.key});

  @override
  Widget build(BuildContext context) {
    final groupMealsByDay = GroupMealsByDayUseCase();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Meal History',
          style: GoogleFonts.dmSans(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.lightOrange,
          ),
        ),
      ),
      body: PaddingWg(
        child: BlocBuilder<MealBloc, MealState>(
          builder: (context, state) {
            if (state is MealLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is MealLoaded) {
              final grouped = groupMealsByDay(state.meals);

              final today = DateTime.now();
              final todayKey = DateTime(today.year, today.month, today.day);
              final yesterdayKey = todayKey.subtract(const Duration(days: 1));

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Today's Meals"),
                  SizedBox(height: 12.h),
                  LastMealWg(meals: grouped[todayKey] ?? []),

                  SizedBox(height: 24.h),

                  Text("Yesterday's Meals"),
                  SizedBox(height: 12.h),
                  LastMealWg(meals: grouped[yesterdayKey] ?? []),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}