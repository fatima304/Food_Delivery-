import 'package:get_it/get_it.dart';
import 'package:food_delivery/data/repositories/auth_repository_impl.dart';
import 'package:food_delivery/domain/repositories/auth_repository.dart';
import 'package:food_delivery/presentation/blocs/auth_cubit.dart';
import 'package:food_delivery/services/auth_service.dart';
import 'package:food_delivery/services/firestore_service.dart';

// Dependency Injection setup
final getIt = GetIt.instance;

void setupDependencies() {
  // Services
   getIt.registerLazySingleton<FirestoreService>(
    () => FirestoreService(),
  );

  getIt.registerLazySingleton<AuthService>(
    () => AuthService(),
  );

  // Authentication
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthService>()),
  );

  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(getIt<AuthRepository>()),
  );

}
