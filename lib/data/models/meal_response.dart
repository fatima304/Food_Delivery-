import 'package:json_annotation/json_annotation.dart';

import 'meal_model.dart';
import 'meal_category_model.dart';
part 'meal_response.g.dart';

@JsonSerializable()
class MealsResponse {
  final List<MealModel>? meals;
  const MealsResponse({this.meals});
  factory MealsResponse.fromJson(Map<String, dynamic> json) =>
      _$MealsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MealsResponseToJson(this);
}

@JsonSerializable()
class CategoriesResponse {
  final List<MealCategoryModel>? categories;
  const CategoriesResponse({this.categories});
  factory CategoriesResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoriesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CategoriesResponseToJson(this);
}
