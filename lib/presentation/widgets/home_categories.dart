import 'package:flutter/material.dart';
import 'package:food_delivery/l10n/app_localizations.dart';

import '../../data/models/meal_category_model.dart';

class HomeCategories extends StatelessWidget {
  const HomeCategories({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelected,
  });
  final List<MealCategoryModel> categories;
  final String? selected;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      height: 43,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final name = i == 0 ? null : categories[i - 1].name;
          final active = selected == name;
          return InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => onSelected(name),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: active
                    ? colors.primaryContainer
                    : colors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                name ?? l10n.all,
                style: TextStyle(
                  color: active ? colors.primary : colors.onSurface,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
