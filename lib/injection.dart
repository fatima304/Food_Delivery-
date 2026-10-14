import 'data/repositories/meal_repository_factory.dart';
import 'presentation/blocs/search_cubit.dart';
import 'presentation/blocs/theme_bloc.dart';
import 'data/datasources/meal_cache_data_source.dart';
import 'data/repositories/profile_repository.dart';
import 'data/repositories/cart_repository.dart';
import 'data/repositories/orders_repository.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'data/repositories/favourites_repository.dart';
import 'presentation/blocs/favourites_cubit.dart';
import 'data/datasources/biometric_datasource.dart';
import 'data/datasources/device_info_datasource.dart';
import 'presentation/blocs/biometric_cubit.dart';
import 'presentation/blocs/device_info_cubit.dart';

import 'package:food_delivery/presentation/blocs/cart_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:food_delivery/presentation/blocs/meal_details_cubit.dart';
import 'package:dio/dio.dart';
import 'package:food_delivery/services/meal_api_service.dart';
import 'package:food_delivery/core/constants/api_constants.dart';
import 'package:food_delivery/domain/repositories/home_repository.dart';
import 'package:food_delivery/presentation/blocs/home_cubit.dart';
import 'package:food_delivery/data/repositories/auth_repository_impl.dart';
import 'package:food_delivery/domain/repositories/auth_repository.dart';
import 'package:food_delivery/presentation/blocs/auth_cubit.dart';
import 'package:food_delivery/services/auth_service.dart';
import 'package:food_delivery/services/firestore_service.dart';

// Dependency Injection setup
final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerFactory<ThemeBloc>(() => ThemeBloc());
  getIt.registerLazySingleton<MealCacheDataSource>(() => MealCacheDataSource());
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepository(FirebaseAuth.instance, FirebaseFirestore.instance),
  );
  getIt.registerLazySingleton<CartRepository>(
    () => CartRepository(FirebaseFirestore.instance, FirebaseAuth.instance),
  );
  getIt.registerLazySingleton<OrdersRepository>(
    () => OrdersRepository(FirebaseFirestore.instance, FirebaseAuth.instance),
  );
  getIt.registerLazySingleton<FavouritesRepository>(
    () =>
        FavouritesRepository(FirebaseFirestore.instance, FirebaseAuth.instance),
  );
  getIt.registerLazySingleton<FavouritesCubit>(
    () => FavouritesCubit(getIt<FavouritesRepository>(), FirebaseAuth.instance),
  );
  getIt.registerLazySingleton<BiometricDataSource>(() => BiometricDataSource());
  getIt.registerLazySingleton<DeviceInfoDataSource>(
    () => DeviceInfoDataSource(),
  );
  getIt.registerFactory<BiometricCubit>(
    () => BiometricCubit(getIt<BiometricDataSource>()),
  );
  getIt.registerFactory<DeviceInfoCubit>(
    () => DeviceInfoCubit(getIt<DeviceInfoDataSource>()),
  );
  // Singleton: one cart instance for the whole authenticated app.
  getIt.registerLazySingleton<CartBloc>(
    () => CartBloc(getIt<CartRepository>(), FirebaseAuth.instance),
  );
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
    () => MealRepositoryFactory.create(
      api: getIt<MealApiService>(),
      cache: getIt<MealCacheDataSource>(),
    ),
  );
  getIt.registerFactory<HomeCubit>(() => HomeCubit(getIt<HomeRepository>()));
  getIt.registerFactory<SearchCubit>(
    () => SearchCubit(getIt<HomeRepository>()),
  );

  getIt.registerFactory<MealDetailsCubit>(
    () => MealDetailsCubit(getIt<HomeRepository>()),
  );

  // Services
  getIt.registerLazySingleton<FirestoreService>(() => FirestoreService());

  getIt.registerLazySingleton<AuthService>(() => AuthService());

  // Authentication
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthService>()),
  );

  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<AuthRepository>()));
}
