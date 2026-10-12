import 'package:json_annotation/json_annotation.dart';
part 'meal_category_model.g.dart';

@JsonSerializable()
class MealCategoryModel {
  @JsonKey(name: 'idCategory', fromJson: _asString)
  final String id;
  @JsonKey(name: 'strCategory', defaultValue: '')
  final String name;
  @JsonKey(name: 'strCategoryThumb', defaultValue: '')
  final String imageUrl;
  const MealCategoryModel({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
  factory MealCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$MealCategoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$MealCategoryModelToJson(this);
  static String _asString(Object? value) => value?.toString() ?? '';
}
