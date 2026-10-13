import 'package:flutter/material.dart';
import 'package:food_delivery/l10n/app_localizations.dart';

import '../../core/constants/app_colors.dart';
import 'ui_parts.dart';

class MealCard extends StatelessWidget {
  const MealCard({super.key, required this.name, required this.price});
  final String name;
  final double price;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return InkWell(
      // onTap: () => Navigator.push(
      // context,
      // MaterialPageRoute(
      //   builder: (_) => MealDetailsScreen(name: name, price: price),
      // ),
      // ),
      child: UiCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FoodPhoto(height: 100),
            const SizedBox(height: 8),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            Text(
              l10n.freshAndDelicious,
              style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '\$${price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => showDemo(context, l10n.addedToCart),
                  icon: const Icon(
                    Icons.add_circle,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
