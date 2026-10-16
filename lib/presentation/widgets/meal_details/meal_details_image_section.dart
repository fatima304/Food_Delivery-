import 'package:flutter/material.dart';
import 'package:food_delivery/data/models/meal_model.dart';

class MealDetailsImageSection extends StatelessWidget {
  const MealDetailsImageSection({
    super.key,
    required this.meal,
    required this.imageHeight,
    required this.onBack,
    required this.onFavorite,
    required this.isFavorite,
  });

  final MealModel meal;
  final double imageHeight;
  final VoidCallback onBack;
  final VoidCallback onFavorite;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final green = colors.primary;

    return Stack(
      children: [
        Image.network(
          meal.imageUrl,
          height: imageHeight,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Container(
            height: imageHeight,
            color: colors.surfaceContainerLow,
            child: Icon(Icons.restaurant_menu_rounded, size: 66, color: green),
          ),
        ),
        PositionedDirectional(
          top: 16,
          start: 18,
          child: _RoundIcon(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: onBack,
          ),
        ),
      ],
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon, required this.onTap})
    : iconColor = null;

  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: colors.surface,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 38,
          height: 38,
          child: Icon(icon, color: iconColor ?? colors.onSurface, size: 20),
        ),
      ),
    );
  }
}
