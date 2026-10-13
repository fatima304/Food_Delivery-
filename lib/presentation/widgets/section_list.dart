import 'package:flutter/material.dart';
import 'package:food_delivery/l10n/app_localizations.dart';
import 'package:food_delivery/presentation/widgets/meal_card.dart';

class MealGrid extends StatelessWidget {
  const MealGrid({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: .76,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      children: [
        MealCard(name: l10n.demoGrilledSalad, price: 7.99),
        MealCard(name: l10n.demoMargheritaPizza, price: 6.50),
        MealCard(name: l10n.demoCheeseBurger, price: 5.99),
        MealCard(name: l10n.demoChickenWrap, price: 4.50),
      ],
    );
  }
}
