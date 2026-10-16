import 'package:flutter/material.dart';
import 'package:food_delivery/l10n/app_localizations.dart';
import 'package:food_delivery/core/widgets/ui_parts.dart';

class OffersCarousel extends StatelessWidget {
  const OffersCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      height: 165,
      child: PageView(
        children: [
          for (final title in [
            l10n.specialOffers,
            l10n.freshMeals,
            l10n.streetFoodFavourites,
          ])
            Card(
              color: colors.primaryContainer,
              elevation: 0,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: colors.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ),
                  const Expanded(child: FoodPhoto(height: 150)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
