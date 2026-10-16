import '../../data/models/meal_model.dart';

class MealDetailsState {
  final MealModel? meal;
  final bool loading;
  final String? error;
  const MealDetailsState({this.meal, this.loading = false, this.error});
}
