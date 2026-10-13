import '../../data/models/meal_model.dart';

abstract class CartEvent {
  const CartEvent();
}

class CartAdd extends CartEvent {
  const CartAdd(this.meal, {this.quantity = 1});
  final MealModel meal;
  final int quantity;
}

class CartIncrease extends CartEvent {
  const CartIncrease(this.mealId);
  final String mealId;
}

class CartDecrease extends CartEvent {
  const CartDecrease(this.mealId);
  final String mealId;
}

class CartRemove extends CartEvent {
  const CartRemove(this.mealId);
  final String mealId;
}

class CartClear extends CartEvent {
  const CartClear();
}
