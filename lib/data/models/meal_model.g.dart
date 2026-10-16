// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MealModel _$MealModelFromJson(Map<String, dynamic> json) => MealModel(
  id: MealModel._asString(json['idMeal']),
  name: json['strMeal'] as String? ?? '',
  imageUrl: json['strMealThumb'] as String? ?? '',
  category: json['strCategory'] as String?,
  area: json['strArea'] as String?,
  instructions: json['strInstructions'] as String?,
  ingredients: (MealModel._readIngredients(json, 'ingredients') as List)
      .cast<String>(),
);

Map<String, dynamic> _$MealModelToJson(MealModel instance) => <String, dynamic>{
  'idMeal': instance.id,
  'strMeal': instance.name,
  'strMealThumb': instance.imageUrl,
  'strCategory': instance.category,
  'strArea': instance.area,
  'strInstructions': instance.instructions,
};
