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
import '../../features/home/data/models/meal_model.dart';
import '../../features/home/domain/use_cases/delete_meal_use_case.dart';
import '../../features/home/domain/use_cases/get_meal_use_case.dart';
import '../../features/home/presentation/bloc/food_prediction/food_prediction_bloc.dart';
import '../../features/home/presentation/bloc/meal/meal_bloc.dart';
import '../../features/home/presentation/bloc/meal/meal_event.dart';

final sl = GetIt.instance;

Future<void> setup() async {
  sl.registerLazySingleton(() => Dio());
  await Hive.initFlutter();
  Hive.registerAdapter(MealModelAdapter());
  await Hive.openBox<MealModel>('meals');

  //! Data sources
  sl.registerLazySingleton<FoodPredictionRemoteDataSource>(
    () => FoodPredictionRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<MealLocalDataSource>(
    () => MealLocalDataSourceImpl(),
  );

  //! Repositories
  sl.registerLazySingleton<FoodPredictionRepo>(
    () => FoodPredictionImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<MealRepo>(() => MealRepositoryImpl(sl()));

  //! Use cases
  sl.registerLazySingleton(() => FoodPredictionUseCase(sl()));
  sl.registerLazySingleton(() => AddMealUseCase(sl()));
  sl.registerLazySingleton(() => GetMealsUseCase(sl()));
  sl.registerLazySingleton(() => DeleteMealUseCase(sl()));

  //! Bloc
  sl.registerLazySingleton(() => FoodPredictionBloc(sl()));
  sl.registerLazySingleton(() => MealBloc(sl(), sl(), sl())..add(LoadMealsEvent()));

}
