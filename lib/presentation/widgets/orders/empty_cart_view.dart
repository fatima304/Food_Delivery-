import 'package:flutter/material.dart';
import 'package:food_delivery/core/constants/app_images.dart';
import 'package:food_delivery/l10n/app_localizations.dart';
import 'package:food_delivery/core/widgets/custom_button.dart';

/// Empty cart illustration and action; kept separate from cart business logic.
class EmptyCartView extends StatelessWidget {
  const EmptyCartView({super.key, required this.onBrowseMeals});

  final VoidCallback onBrowseMeals;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AppImages.emptyCart,
                width: (MediaQuery.sizeOf(context).width - 56).clamp(
                  0.0,
                  270.0,
                ),
                height: (MediaQuery.sizeOf(context).height * .28).clamp(
                  140.0,
                  230.0,
                ),
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => Icon(
                  Icons.remove_shopping_cart_outlined,
                  size: 115,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.yourCartEmpty,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.addMealsToGetStarted,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 30),
              CustomButton(text: l10n.browseMeals, onPressed: onBrowseMeals),
            ],
          ),
        ),
      ),
    );
  }
}
