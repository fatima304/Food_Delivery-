import 'package:flutter/material.dart';

import '../../../data/models/meal_model.dart';
import '../common/meal_card_details.dart';
import '../common/meal_image.dart';

class SearchMealCard extends StatelessWidget {
  const SearchMealCard({super.key, required this.meal, required this.onTap});

  final MealModel meal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      color: colors.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: MealImage(
                imageUrl: meal.imageUrl,
                placeholderIcon: Icons.restaurant_menu,
                placeholderSize: 42,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: MealCardDetails(meal: meal, showCategory: true),
            ),
          ],
        ),
      ),
    );
  }
}
