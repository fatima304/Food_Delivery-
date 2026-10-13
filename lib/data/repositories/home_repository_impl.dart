import '../../domain/repositories/home_repository.dart';
import '../../services/meal_api_service.dart';
import '../models/meal_model.dart';
import '../models/meal_category_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final MealApiService api;
  HomeRepositoryImpl(this.api);

  @override
  Future<MealModel?> getMealDetails(String id) async {
    final meals = (await api.mealDetails(id)).meals;
    return meals == null || meals.isEmpty ? null : meals.first;
  }

  @override
  Future<List<MealModel>> searchMeals(String query) async =>
      (await api.searchMeals(query)).meals ?? [];

  @override
  Future<List<MealCategoryModel>> getCategories() async =>
      (await api.fetchCategories()).categories ?? [];

  @override
  Future<List<MealModel>> getMeals({String? category}) async {
    final response = category == null
        ? await api.searchMeals('')
        : await api.filterMeals(category);
    return response.meals ?? [];
  }
}
