import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:food_delivery/services/meal_api_service.dart';
import 'package:food_delivery/core/constants/api_constants.dart';
import 'package:food_delivery/domain/repositories/home_repository.dart';
import 'package:food_delivery/data/repositories/home_repository_impl.dart';
import 'package:food_delivery/presentation/blocs/home_cubit.dart';
import 'package:food_delivery/data/repositories/auth_repository_impl.dart';
import 'package:food_delivery/domain/repositories/auth_repository.dart';
import 'package:food_delivery/presentation/blocs/auth_cubit.dart';
import 'package:food_delivery/services/auth_service.dart';
import 'package:food_delivery/services/firestore_service.dart';

// Dependency Injection setup
final getIt = GetIt.instance;

void setupDependencies() {
  // Home (TheMealDB)
  getIt.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    ),
  );
  getIt.registerLazySingleton<MealApiService>(
    () => MealApiService(getIt<Dio>()),
  );
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(getIt<MealApiService>()),
  );
  getIt.registerFactory<HomeCubit>(() => HomeCubit(getIt<HomeRepository>()));

  // Services
  getIt.registerLazySingleton<FirestoreService>(() => FirestoreService());

  getIt.registerLazySingleton<AuthService>(() => AuthService());

  // Authentication
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthService>()),
  );

  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<AuthRepository>()));
}
