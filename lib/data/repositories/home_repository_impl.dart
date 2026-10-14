import '../../domain/repositories/home_repository.dart';
import '../../services/meal_api_service.dart';
import '../models/meal_model.dart';
import '../models/meal_category_model.dart';
import '../datasources/meal_cache_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final MealApiService api;
  final MealCacheDataSource cache;
  HomeRepositoryImpl(this.api, this.cache);

  @override
  Future<MealModel?> getMealDetails(String id) async {
    final meals = (await api.mealDetails(id)).meals;
    return meals == null || meals.isEmpty ? null : meals.first;
  }

  @override
  Future<List<MealModel>> searchMeals(String query) async =>
      (await api.searchMeals(query)).meals ?? [];

  @override
  Future<List<MealCategoryModel>> getCategories() async {
    try {
      final categories = (await api.fetchCategories()).categories ?? [];
      await cache.saveCategories(categories);
      return categories;
    } catch (_) {
      final cached = await cache.readCategories();
      if (cached != null) return cached;
      rethrow;
    }
  }

  @override
  Future<List<MealModel>> getMeals({String? category}) async {
    final key = category == null ? 'all' : 'category_$category';
    try {
      final response = category == null
          ? await api.searchMeals('')
          : await api.filterMeals(category);
      final meals = response.meals ?? [];
      await cache.saveMeals(key, meals);
      return meals;
    } catch (_) {
      final cached = await cache.readMeals(key);
      if (cached != null) return cached;
      rethrow;
    }
  }
}
