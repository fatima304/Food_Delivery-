import '../../domain/repositories/home_repository.dart';
import '../../services/meal_api_service.dart';
import '../datasources/meal_cache_data_source.dart';
import 'home_repository_impl.dart';

/// Creates the meal repository with its remote API and local cache.
/// The repository keeps the existing API-first, cache-on-error behavior.
class MealRepositoryFactory {
  const MealRepositoryFactory._();

  static HomeRepository create({
    required MealApiService api,
    required MealCacheDataSource cache,
  }) {
    return HomeRepositoryImpl(api, cache);
  }
}
