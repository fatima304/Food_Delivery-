import '../../data/models/meal_model.dart';
import '../../data/models/meal_category_model.dart';

class HomeState {
  final bool loading;
  final List<MealCategoryModel> categories;
  final List<MealModel> meals;
  final List<MealModel> offers;
  final String? selectedCategory;
  final String? error;
  const HomeState({
    this.loading = false,
    this.categories = const [],
    this.meals = const [],
    this.offers = const [],
    this.selectedCategory,
    this.error,
  });
}
