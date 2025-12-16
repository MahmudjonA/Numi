import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:numi/features/home/domain/entities/meal.dart';
import 'package:numi/features/home/presentation/bloc/meal/meal_bloc.dart';
import 'package:numi/features/home/presentation/bloc/meal/meal_event.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/constants/food_calories.dart';

class CategoryMealsPage extends StatelessWidget {
  final String categoryName;
  final List<String> images;

  const CategoryMealsPage({
    super.key,
    required this.categoryName,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName.replaceAll('_', ' ')),
        backgroundColor: AppColors.backgroundLight,
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          final imagePath = images[index];
          final mealName = imagePath.split('/').last.split('.').first;
          final calories = getCaloriesByName(mealName);
          return GestureDetector(
            onTap: () {
              final meal = Meal(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: mealName,
                calories: calories,
                category: categoryName,
                dateTime: DateTime.now(),
                imagePath: imagePath,
              );

              context.read<MealBloc>().add(AddMealEvent(meal: meal));

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('$mealName added')));
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: AppColors.lightGrey,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(imagePath, height: 60.h),
                  SizedBox(height: 8.h),
                  Text(
                    mealName.replaceAll('_', ' '),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
