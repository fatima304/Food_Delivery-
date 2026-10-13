import '../../data/models/meal_category_model.dart';
import '../../data/models/meal_model.dart';

class SearchState {
  final List<MealCategoryModel> categories;
  final List<MealModel> meals;
  final String query;
  final String? selectedCategory;
  final bool loading;
  final String? error;

  const SearchState({
    this.categories = const [],
    this.meals = const [],
    this.query = '',
    this.selectedCategory,
    this.loading = false,
    this.error,
  });
}
