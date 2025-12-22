import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:numi/core/constants/extensions/string_extensions.dart';
import 'package:numi/core/widgets/padding_wg.dart';
import 'package:numi/features/home/presentation/pages/daily_calories_page.dart';
import 'package:numi/features/home/presentation/widgets/app_bar_wg.dart';
import 'package:numi/features/home/presentation/widgets/banners_wg.dart';
import 'package:numi/features/home/presentation/widgets/categories_wg.dart';
import 'package:numi/features/home/presentation/widgets/last_meal_wg.dart';
import '../../../../core/constants/food_calories.dart';
import '../../domain/entities/meal.dart';
import '../../domain/use_cases/group_meals_by_day_use_case.dart';
import '../bloc/food_prediction/food_prediction_bloc.dart';
import '../bloc/food_prediction/food_prediction_state.dart';
import '../bloc/meal/meal_bloc.dart';
import '../bloc/meal/meal_event.dart';
import '../bloc/meal/meal_state.dart';
import '../widgets/daily_calories_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<FoodPredictionBloc, FoodPredictionState>(
      listener: (context, state) {
        if (state is FoodPredictionLoading) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Processing image...")));
        }

        if (state is FoodPredictionSuccess) {
          final foodName = state.predictionResult.name.capitalize();
          final calories = getCaloriesByName(foodName);

          final meal = Meal(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: foodName,
            calories: calories,
            category: 'AI',
            dateTime: DateTime.now(),
            imagePath: null,
          );

          context.read<MealBloc>().add(AddMealEvent(meal: meal));

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("$foodName added ($calories kcal)")),
          );
        }

        if (state is FoodPredictionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error: ${state.message}"),
              backgroundColor: Colors.red,
            ),
          );
        }
      },

      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBarWg(),
        ),
        body: PaddingWg(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DailyCaloriesCard(
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        return const DailyCaloriesPage();
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 20.h),
              BannersWg(),
              SizedBox(height: 15.h),
              Row(
                children: [
                  Text(
                    "Categories",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              CategoriesWg(),
              SizedBox(height: 20.h),
              Text("Last Meals", style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 10.h),
              BlocBuilder<MealBloc, MealState>(
                builder: (context, state) {
                  if (state is MealLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    );
                  }

                  if (state is MealLoaded) {
                    final groupMealsByDay = GroupMealsByDayUseCase();
                    final grouped = groupMealsByDay(state.meals);
                    final today = DateTime.now();
                    final todayKey = DateTime(
                      today.year,
                      today.month,
                      today.day,
                    );

                    return LastMealWg(meals: grouped[todayKey] ?? []);
                  }
                  return SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
