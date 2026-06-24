import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../features/home/data/data_sources/local/custom_food_local_data_source.dart';
import '../../features/home/data/data_sources/local/custom_food_local_data_source_impl.dart';
import '../../features/home/data/data_sources/local/meal_local_data_source.dart';
import '../../features/home/data/data_sources/local/meal_local_data_source_impl.dart';
import '../../features/home/data/data_sources/local/user_body_local_data_source.dart';
import '../../features/home/data/data_sources/local/user_body_local_data_source_impl.dart';
import '../../features/home/data/data_sources/local/water_intake_local_data_source.dart';
import '../../features/home/data/data_sources/local/water_intake_local_data_source_impl.dart';
import '../../features/home/data/data_sources/local/weight_entry_local_data_source.dart';
import '../../features/home/data/data_sources/local/weight_entry_local_data_source_impl.dart';
import '../../features/home/data/data_sources/remote/food_prediction_remote_data_source.dart';
import '../../features/home/data/data_sources/remote/food_prediction_remote_data_source_impl.dart';
import '../../features/home/data/models/custom_food_model.dart';
import '../../features/home/data/models/meal_model.dart';
import '../../features/home/data/models/user_body_info_model.dart';
import '../../features/home/data/models/water_intake_model.dart';
import '../../features/home/data/models/weight_entry_model.dart';
import '../../features/home/data/repositories/custom_food_repository_impl.dart';
import '../../features/home/data/repositories/food_prediction_repository_impl.dart';
import '../../features/home/data/repositories/meal_repository_impl.dart';
import '../../features/home/data/repositories/user_body_repository_impl.dart';
import '../../features/home/data/repositories/water_intake_repository_impl.dart';
import '../../features/home/data/repositories/weight_entry_repository_impl.dart';
import '../../features/home/domain/repositories/custom_food_repo.dart';
import '../../features/home/domain/repositories/food_prediction_repo.dart';
import '../../features/home/domain/repositories/meal_repo.dart';
import '../../features/home/domain/repositories/user_body_repo.dart';
import '../../features/home/domain/repositories/water_intake_repo.dart';
import '../../features/home/domain/repositories/weight_entry_repo.dart';
import '../../features/home/domain/use_cases/add_custom_food_use_case.dart';
import '../../features/home/domain/use_cases/add_meal_use_case.dart';
import '../../features/home/domain/use_cases/add_weight_entry_use_case.dart';
import '../../features/home/domain/use_cases/calculate_daily_calories_use_case.dart';
import '../../features/home/domain/use_cases/delete_custom_food_use_case.dart';
import '../../features/home/domain/use_cases/delete_meal_use_case.dart';
import '../../features/home/domain/use_cases/delete_weight_entry_use_case.dart';
import '../../features/home/domain/use_cases/food_prediction_use_case.dart';
import '../../features/home/domain/use_cases/get_custom_foods_use_case.dart';
import '../../features/home/domain/use_cases/get_meal_use_case.dart';
import '../../features/home/domain/use_cases/get_user_body_info_use_case.dart';
import '../../features/home/domain/use_cases/get_weight_history_use_case.dart';
import '../../features/home/domain/use_cases/save_user_body_info_use_case.dart';
import '../../features/home/presentation/bloc/custom_food/custom_food_bloc.dart';
import '../../features/home/presentation/bloc/food_prediction/food_prediction_bloc.dart';
import '../../features/home/presentation/bloc/meal/meal_bloc.dart';
import '../../features/home/presentation/bloc/meal/meal_event.dart';
import '../../features/home/presentation/bloc/user_body_info/user_body_info_bloc.dart';
import '../../features/home/presentation/bloc/user_body_info/user_body_info_event.dart';
import '../../features/home/presentation/bloc/water/water_bloc.dart';
import '../../features/home/presentation/bloc/water/water_event.dart';
import '../../features/home/presentation/bloc/weight/weight_bloc.dart';
import '../../features/home/presentation/bloc/weight/weight_event.dart';

final sl = GetIt.instance;

Future<void> setup() async {
  sl.registerLazySingleton(() => Dio());
  await Hive.initFlutter();

  // Adapters
  Hive.registerAdapter(MealModelAdapter());
  Hive.registerAdapter(UserBodyInfoModelAdapter());
  Hive.registerAdapter(CustomFoodModelAdapter());
  Hive.registerAdapter(WeightEntryModelAdapter());
  Hive.registerAdapter(WaterIntakeModelAdapter());

  // Boxes
  await Hive.openBox<MealModel>('meals');
  await Hive.openBox<UserBodyInfoModel>('user_body');
  await Hive.openBox<CustomFoodModel>('custom_foods');
  await Hive.openBox<WeightEntryModel>('weight_entries');
  await Hive.openBox<WaterIntakeModel>('water_intake');
  await Hive.openBox('settings');

  //! Data sources
  sl.registerLazySingleton<FoodPredictionRemoteDataSource>(
    () => FoodPredictionRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<MealLocalDataSource>(
    () => MealLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<UserBodyLocalDataSource>(
    () => UserBodyLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<CustomFoodLocalDataSource>(
    () => CustomFoodLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<WeightEntryLocalDataSource>(
    () => WeightEntryLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<WaterIntakeLocalDataSource>(
    () => WaterIntakeLocalDataSourceImpl(),
  );

  //! Repositories
  sl.registerLazySingleton<FoodPredictionRepo>(
    () => FoodPredictionImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<MealRepo>(() => MealRepositoryImpl(sl()));
  sl.registerLazySingleton<UserBodyRepo>(() => UserBodyRepositoryImpl(sl()));
  sl.registerLazySingleton<CustomFoodRepo>(
    () => CustomFoodRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<WeightEntryRepo>(
    () => WeightEntryRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<WaterIntakeRepo>(
    () => WaterIntakeRepositoryImpl(sl()),
  );

  //! Use cases
  sl.registerLazySingleton(() => FoodPredictionUseCase(sl()));
  sl.registerLazySingleton(() => AddMealUseCase(sl()));
  sl.registerLazySingleton(() => GetMealsUseCase(sl()));
  sl.registerLazySingleton(() => DeleteMealUseCase(sl()));
  sl.registerLazySingleton(() => GetUserBodyInfoUseCase(sl()));
  sl.registerLazySingleton(() => SaveUserBodyInfoUseCase(sl()));
  sl.registerLazySingleton(() => CalculateDailyCaloriesUseCase());
  sl.registerLazySingleton(() => AddCustomFoodUseCase(sl()));
  sl.registerLazySingleton(() => GetCustomFoodsUseCase(sl()));
  sl.registerLazySingleton(() => DeleteCustomFoodUseCase(sl()));
  sl.registerLazySingleton(() => AddWeightEntryUseCase(sl()));
  sl.registerLazySingleton(() => GetWeightHistoryUseCase(sl()));
  sl.registerLazySingleton(() => DeleteWeightEntryUseCase(sl()));

  //! BLoCs
  sl.registerLazySingleton(() => FoodPredictionBloc(sl()));
  sl.registerLazySingleton(
    () => MealBloc(sl(), sl(), sl())..add(LoadMealsEvent()),
  );
  sl.registerLazySingleton(
    () => UserBodyInfoBloc(sl(), sl(), sl())..add(LoadUserBodyInfoEvent()),
  );
  sl.registerLazySingleton(
    () => CustomFoodBloc(sl(), sl(), sl()),
  );
  sl.registerLazySingleton(
    () => WeightBloc(sl(), sl(), sl())..add(LoadWeightHistoryEvent()),
  );
  sl.registerLazySingleton(
    () => WaterBloc(sl(), sl())..add(LoadWaterEvent()),
  );
}
