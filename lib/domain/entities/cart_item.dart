import '../../data/models/meal_model.dart';

class CartItem {
  const CartItem({required this.meal, required this.quantity});

  final MealModel meal;
  final int quantity;

  double get total => meal.price * quantity;

  CartItem copyWith({int? quantity}) => CartItem(
        meal: meal,
        quantity: quantity ?? this.quantity,
      );
}
