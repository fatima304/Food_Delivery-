import 'package:flutter/material.dart';
import 'package:food_delivery/presentation/widgets/meal_card.dart';

class MealGrid extends StatelessWidget {
  const MealGrid({super.key});
  @override
  Widget build(BuildContext context) => GridView.count(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    crossAxisCount: 2,
    childAspectRatio: .76,
    crossAxisSpacing: 8,
    mainAxisSpacing: 8,
    children: const [
      MealCard(name: 'Grilled Chicken Salad', price: 7.99),
      MealCard(name: 'Margherita Pizza', price: 6.50),
      MealCard(name: 'Cheese Burger', price: 5.99),
      MealCard(name: 'Chicken Wrap', price: 4.50),
    ],
  );
}
