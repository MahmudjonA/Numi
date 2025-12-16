import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numi/core/widgets/padding_wg.dart';
import 'package:numi/features/home/presentation/widgets/app_bar_wg.dart';
import 'package:numi/features/home/presentation/widgets/banners_wg.dart';
import 'package:numi/features/home/presentation/widgets/categories_wg.dart';
import 'package:numi/features/home/presentation/widgets/last_meal_wg.dart';
import '../bloc/food_prediction/food_prediction_bloc.dart';
import '../bloc/food_prediction/food_prediction_state.dart';
import '../bloc/meal/meal_bloc.dart';
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Detected: ${state.predictionResult.name.toUpperCase()}",
              ),
            ),
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
              DailyCaloriesCard(onPress: () {}),
              SizedBox(height: 20.h),
              BannersWg(),
              SizedBox(height: 15.h),
              Row(
                children: [
                  Text(
                    "Categories",
                    style: GoogleFonts.dmSans(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              CategoriesWg(),
              SizedBox(height: 20.h),
              Text(
                "Last Meals",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.h),
              BlocBuilder<MealBloc, MealState>(
                builder: (context, state) {
                  if (state is MealLoading) {
                    return CircularProgressIndicator();
                  }

                  if (state is MealLoaded) {
                    return LastMealWg(meals: state.meals);
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
