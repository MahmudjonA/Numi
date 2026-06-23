import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numi/features/home/presentation/bloc/meal/meal_bloc.dart';
import 'package:numi/features/home/presentation/bloc/user_body_info/user_body_info_bloc.dart';

import 'core/di/service_locator.dart';
import 'features/home/presentation/bloc/custom_food/custom_food_bloc.dart';
import 'features/home/presentation/bloc/food_prediction/food_prediction_bloc.dart';
import 'features/home/presentation/bloc/water/water_bloc.dart';
import 'features/home/presentation/bloc/weight/weight_bloc.dart';

class MyBlocProvider extends StatelessWidget {
  const MyBlocProvider({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FoodPredictionBloc>(
          create: (_) => sl<FoodPredictionBloc>(),
        ),
        BlocProvider<MealBloc>(create: (_) => sl<MealBloc>()),
        BlocProvider<UserBodyInfoBloc>(
          create: (_) => sl<UserBodyInfoBloc>(),
        ),
        BlocProvider<CustomFoodBloc>(
          create: (_) => sl<CustomFoodBloc>(),
        ),
        BlocProvider<WeightBloc>(create: (_) => sl<WeightBloc>()),
        BlocProvider<WaterBloc>(create: (_) => sl<WaterBloc>()),
      ],
      child: child,
    );
  }
}
