import 'package:flutter/material.dart';
import 'package:food_delivery/core/style/app_text_styles.dart';
import 'package:food_delivery/data/models/meal_model.dart';
import 'package:food_delivery/l10n/app_localizations.dart';

class MealDetailsQuantitySection extends StatelessWidget {
  const MealDetailsQuantitySection({
    super.key,
    required this.meal,
    required this.quantity,
    required this.onQuantityChanged,
    required this.onAddToCart,
  });

  final MealModel meal;
  final int quantity;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final green = colors.primary;
    final muted = colors.onSurfaceVariant;
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Container(
          height: 46,
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: colors.outlineVariant.withValues(alpha: .55),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _QuantityButton(
                icon: Icons.remove_rounded,
                onTap: quantity > 1
                    ? () => onQuantityChanged(quantity - 1)
                    : null,
                color: muted,
              ),
              Text(
                '$quantity',
                style: AppTextStyles.body16DarkRegular.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.onSurface,
                ),
              ),
              _QuantityButton(
                icon: Icons.add_rounded,
                onTap: () => onQuantityChanged(quantity + 1),
                color: colors.onSurface,
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SizedBox(
            height: 46,
            child: ElevatedButton(
              onPressed: onAddToCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: green,
                foregroundColor: colors.onPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                l10n.addToCart,
                style: AppTextStyles.button16WhiteSemiBold.copyWith(
                  color: colors.onPrimary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.onTap,
    required this.color,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, size: 18, color: color),
      constraints: const BoxConstraints(minWidth: 35, minHeight: 42),
      padding: EdgeInsets.zero,
    );
  }
}
