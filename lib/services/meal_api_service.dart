import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../core/constants/api_constants.dart';
import '../data/models/meal_response.dart';
part 'meal_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class MealApiService {
  factory MealApiService(Dio dio, {String? baseUrl}) = _MealApiService;

  @GET(ApiConstants.categories)
  Future<CategoriesResponse> fetchCategories();

  @GET(ApiConstants.search)
  Future<MealsResponse> searchMeals(@Query('s') String query);

  @GET(ApiConstants.filterBy)
  Future<MealsResponse> filterMeals(@Query('c') String category);

  @GET(ApiConstants.areas)
  Future<Map<String, dynamic>> fetchAreas(@Query('a') String value);

  @GET(ApiConstants.filterBy)
  Future<MealsResponse> filterMealsByArea(@Query('a') String area);

  @GET(ApiConstants.mealDetails)
  Future<MealsResponse> mealDetails(@Query('i') String id);
}
