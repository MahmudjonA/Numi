import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:numi/features/home/data/data_sources/local/meal_local_data_source.dart';
import 'package:numi/features/home/data/data_sources/local/meal_local_data_source_impl.dart';
import 'package:numi/features/home/data/data_sources/remote/food_prediction_remote_data_source.dart';
import 'package:numi/features/home/data/data_sources/remote/food_prediction_remote_data_source_impl.dart';
import 'package:numi/features/home/data/repositories/food_prediction_repository_impl.dart';
import 'package:numi/features/home/data/repositories/meal_repository_impl.dart';
import 'package:numi/features/home/domain/repositories/food_prediction_repo.dart';
import 'package:numi/features/home/domain/repositories/meal_repo.dart';
import 'package:numi/features/home/domain/use_cases/add_meal_use_case.dart';
import 'package:numi/features/home/domain/use_cases/food_prediction_use_case.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../features/home/data/data_sources/local/user_body_local_data_source.dart';
import '../../features/home/data/data_sources/local/user_body_local_data_source_impl.dart';
import '../../features/home/data/models/meal_model.dart';
import '../../features/home/data/models/user_body_info_model.dart';
import '../../features/home/data/repositories/user_body_repository_impl.dart';
import '../../features/home/domain/repositories/user_body_repo.dart';
import '../../features/home/domain/use_cases/calculate_daily_calories_use_case.dart';
import '../../features/home/domain/use_cases/delete_meal_use_case.dart';
import '../../features/home/domain/use_cases/get_meal_use_case.dart';
import '../../features/home/domain/use_cases/get_user_body_info_use_case.dart';
import '../../features/home/domain/use_cases/save_user_body_info_use_case.dart';
import '../../features/home/presentation/bloc/food_prediction/food_prediction_bloc.dart';
import '../../features/home/presentation/bloc/meal/meal_bloc.dart';
import '../../features/home/presentation/bloc/meal/meal_event.dart';
import '../../features/home/presentation/bloc/user_body_info/user_body_info_bloc.dart';
import '../../features/home/presentation/bloc/user_body_info/user_body_info_event.dart';

final sl = GetIt.instance;

Future<void> setup() async {
  sl.registerLazySingleton(() => Dio());
  await Hive.initFlutter();

  Hive.registerAdapter(MealModelAdapter());
  Hive.registerAdapter(UserBodyInfoModelAdapter());

  await Hive.openBox<MealModel>('meals');
  await Hive.openBox<UserBodyInfoModel>('user_body');

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

  //! Repositories
  sl.registerLazySingleton<FoodPredictionRepo>(
    () => FoodPredictionImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<MealRepo>(() => MealRepositoryImpl(sl()));

  sl.registerLazySingleton<UserBodyRepo>(() => UserBodyRepositoryImpl(sl()));

  //! Use cases
  sl.registerLazySingleton(() => FoodPredictionUseCase(sl()));
  sl.registerLazySingleton(() => AddMealUseCase(sl()));
  sl.registerLazySingleton(() => GetMealsUseCase(sl()));
  sl.registerLazySingleton(() => DeleteMealUseCase(sl()));
  sl.registerLazySingleton(() => GetUserBodyInfoUseCase(sl()));
  sl.registerLazySingleton(() => SaveUserBodyInfoUseCase(sl()));
  sl.registerLazySingleton(() => CalculateDailyCaloriesUseCase());


  //! Bloc
  sl.registerLazySingleton(() => FoodPredictionBloc(sl()));
  sl.registerLazySingleton(
    () => MealBloc(sl(), sl(), sl())..add(LoadMealsEvent()),
  );

  sl.registerLazySingleton(
    () => UserBodyInfoBloc(sl(), sl(),sl())..add(LoadUserBodyInfoEvent()),
  );
}
