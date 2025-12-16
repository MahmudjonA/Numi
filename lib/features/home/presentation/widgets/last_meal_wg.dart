import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/app_colors.dart';
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
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.searchTextColor,
          ),
        ),
      );
    }

    final int totalCalories =
    meals.fold(0, (sum, meal) => sum + meal.calories);
    final DateTime date = meals.first.dateTime;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: AppColors.bg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Consumed",
                style: GoogleFonts.dmSans(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.greenColor,
                ),
              ),
              const Spacer(),
              Text(
                "$totalCalories kcal",
                style: GoogleFonts.dmSans(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.greenColor,
                ),
              ),
            ],
          ),

          SizedBox(height: 4.h),

          Text(
            formatDate(date),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 12.h),

          Column(
            children: meals.map((meal) {
              return Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.all(12.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: AppColors.lightGrey,
                ),
                child: Row(
                  children: [
                    meal.imagePath != null
                        ? Image.asset(meal.imagePath!, width: 40.w)
                        : Icon(Icons.fastfood, size: 40),

                    SizedBox(width: 12.w),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meal.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                        Text("${meal.calories} kcal"),
                      ],
                    ),

                    const Spacer(),

                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        context
                            .read<MealBloc>()
                            .add(DeleteMealEvent(id: meal.id));
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
