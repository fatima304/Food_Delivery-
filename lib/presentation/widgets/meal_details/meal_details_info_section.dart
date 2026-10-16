import 'package:flutter/material.dart';
import 'package:food_delivery/core/style/app_text_styles.dart';
import 'package:food_delivery/data/models/meal_model.dart';
import 'package:food_delivery/l10n/app_localizations.dart';
import 'package:food_delivery/presentation/widgets/meal_details/info_chip.dart';
import 'package:food_delivery/presentation/widgets/meal_details/section_title.dart';

class MealDetailsInfoSection extends StatelessWidget {
  const MealDetailsInfoSection({
    super.key,
    required this.meal,
    required this.isFavorite,
    required this.onFavorite,
  });

  final MealModel meal;
  final bool isFavorite;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final green = colors.primary;
    final muted = colors.onSurfaceVariant;
    final l10n = AppLocalizations.of(context)!;

    return Transform.translate(
      offset: const Offset(0, -18),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    meal.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.heading24BlackBold.copyWith(
                      fontSize: 23,
                      color: colors.onSurface,
                      height: 1.25,
                    ),
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                  onPressed: onFavorite,
                  icon: Icon(
                    isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: isFavorite ? colors.error : muted,
                    size: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 7),
            Row(
              children: [
                Text(
                  '\$${meal.price.toStringAsFixed(2)}',
                  style: AppTextStyles.heading24BlackBold.copyWith(
                    fontSize: 22,
                    color: green,
                  ),
                ),
                const SizedBox(width: 13),
                Icon(
                  Icons.star_rounded,
                  color: Colors.amber.shade700,
                  size: 17,
                ),
                const SizedBox(width: 3),
                Text(
                  l10n.freshMeal,
                  style: AppTextStyles.body14GreyRegular.copyWith(color: muted),
                ),
              ],
            ),
            const SizedBox(height: 17),
            Wrap(
              spacing: 18,
              runSpacing: 8,
              children: [
                InfoChip(
                  key: const Key('fresh'),
                  icon: Icons.verified_outlined,
                  text: l10n.fresh,
                  green: green,
                  muted: muted,
                ),
                if (meal.category?.isNotEmpty == true)
                  InfoChip(
                    key: Key('category-${meal.category}'),
                    icon: Icons.restaurant_menu_outlined,
                    text: meal.category!,
                    green: green,
                    muted: muted,
                  ),
                if (meal.area?.isNotEmpty == true)
                  InfoChip(
                    key: Key('area-${meal.area}'),
                    icon: Icons.public_rounded,
                    text: meal.area!,
                    green: green,
                    muted: muted,
                  ),
              ],
            ),
            const SizedBox(height: 22),
            if (meal.category?.isNotEmpty == true) ...[
              SectionTitle(
                key: const Key('category-title'),
                title: l10n.category,
                color: colors.onSurface,
              ),
              const SizedBox(height: 5),
              Text(
                meal.category!,
                style: AppTextStyles.body14GreyRegular.copyWith(color: muted),
              ),
              const SizedBox(height: 18),
            ],
            if (meal.area?.isNotEmpty == true) ...[
              SectionTitle(
                key: const Key('origin-title'),
                title: l10n.origin,
                color: colors.onSurface,
              ),
              const SizedBox(height: 5),
              Text(
                meal.area!,
                style: AppTextStyles.body14GreyRegular.copyWith(color: muted),
              ),
              const SizedBox(height: 22),
            ],
          ],
        ),
      ),
    );
  }
}
