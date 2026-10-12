// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MealCategoryModel _$MealCategoryModelFromJson(Map<String, dynamic> json) =>
    MealCategoryModel(
      id: MealCategoryModel._asString(json['idCategory']),
      name: json['strCategory'] as String? ?? '',
      imageUrl: json['strCategoryThumb'] as String? ?? '',
    );

Map<String, dynamic> _$MealCategoryModelToJson(MealCategoryModel instance) =>
    <String, dynamic>{
      'idCategory': instance.id,
      'strCategory': instance.name,
      'strCategoryThumb': instance.imageUrl,
    };
