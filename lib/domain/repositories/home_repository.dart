import '../../data/models/meal_model.dart';
import '../../data/models/meal_category_model.dart';

abstract class HomeRepository {
  Future<List<MealCategoryModel>> getCategories();
  Future<List<MealModel>> getMeals({String? category});
  Future<MealModel?> getMealDetails(String id);
}
