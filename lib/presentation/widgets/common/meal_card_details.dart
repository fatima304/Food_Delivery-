import 'package:flutter/material.dart';
import 'package:food_delivery/l10n/app_localizations.dart';

import '../../../data/models/meal_model.dart';

/// Shared meal name and price, with optional category and action button.
class MealCardDetails extends StatelessWidget {
  const MealCardDetails({
    super.key,
    required this.meal,
    this.showCategory = false,
    this.trailing,
    this.nameStyle,
    this.priceStyle,
  });

  final MealModel meal;
  final bool showCategory;
  final Widget? trailing;
  final TextStyle? nameStyle;
  final TextStyle? priceStyle;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          meal.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: nameStyle ?? const TextStyle(fontWeight: FontWeight.w700),
        ),
        SizedBox(height: showCategory ? 4 : 6),
        if (showCategory) ...[
          Text(
            meal.category ?? l10n.meal,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 5),
        ],
        Row(
          children: [
            Expanded(
              child: Text(
                '\$${meal.price.toStringAsFixed(2)}',
                style:
                    priceStyle ??
                    TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
              ),
            ),
            ?trailing,
          ],
        ),
      ],
    );
  }
}
