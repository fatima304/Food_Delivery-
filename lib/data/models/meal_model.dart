import 'package:json_annotation/json_annotation.dart';
part 'meal_model.g.dart';

@JsonSerializable()
class MealModel {
  @JsonKey(name: 'idMeal', fromJson: _asString)
  final String id;
  @JsonKey(name: 'strMeal', defaultValue: '')
  final String name;
  @JsonKey(name: 'strMealThumb', defaultValue: '')
  final String imageUrl;
  @JsonKey(name: 'strCategory')
  final String? category;
  @JsonKey(name: 'strArea')
  final String? area;
  @JsonKey(name: 'strInstructions')
  final String? instructions;

  const MealModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.category,
    this.area,
    this.instructions,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) =>
      _$MealModelFromJson(json);
  Map<String, dynamic> toJson() => _$MealModelToJson(this);
  static String _asString(Object? value) => value?.toString() ?? '';
  double get price => DemoMealPricing.priceFor(id);
}

/// Demo prices only: TheMealDB API does not provide real prices.
class DemoMealPricing {
  static const Map<String, double> overrides = {
    '52772': 7.99,
    '52802': 6.50,
    '52813': 5.99,
  };
  static double priceFor(String id) {
    final custom = overrides[id];
    if (custom != null) return custom;
    final number =
        int.tryParse(id) ?? id.codeUnits.fold<int>(0, (a, b) => a + b);
    return 4.99 + (number % 9);
  }
}
