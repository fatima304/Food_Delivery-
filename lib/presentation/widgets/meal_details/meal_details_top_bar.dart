import 'package:flutter/material.dart';
import 'package:food_delivery/core/style/app_text_styles.dart';
import 'package:food_delivery/l10n/app_localizations.dart';

class MealDetailsTopBar extends StatelessWidget {
  const MealDetailsTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final titleStyle = AppTextStyles.heading24BlackBold.copyWith(
      color: colors.onSurface,
      fontSize: 19,
      height: 1.2,
    );

    return SizedBox(
      height: 48,
      child: Center(child: Text(l10n.mealDetails, style: titleStyle)),
    );
  }
}
