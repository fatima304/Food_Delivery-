import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery/l10n/app_localizations.dart';

import '../../blocs/favourites_cubit.dart';

import '../../../data/models/meal_model.dart';
import '../../../core/style/app_text_styles.dart';
import '../common/meal_image.dart';
import '../common/meal_card_details.dart';

class HomeMealCard extends StatelessWidget {
  const HomeMealCard({super.key, required this.meal, this.onAdd});
  final MealModel meal;
  final ValueChanged<MealModel>? onAdd;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: .42)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  MealImage(imageUrl: meal.imageUrl),
                  Positioned(
                    top: 7,
                    right: 7,
                    child: BlocBuilder<FavouritesCubit, FavouritesState>(
                      builder: (context, state) => Material(
                        color: scheme.surface.withValues(alpha: .9),
                        shape: const CircleBorder(),
                        child: IconButton(
                          iconSize: 20,
                          visualDensity: VisualDensity.compact,
                          tooltip: l10n.toggleFavourite,
                          onPressed: () =>
                              context.read<FavouritesCubit>().toggle(meal),
                          icon: Icon(
                            state.contains(meal.id)
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: state.contains(meal.id)
                                ? Colors.red
                                : scheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 9, 8, 10),
            child: MealCardDetails(
              meal: meal,
              nameStyle: AppTextStyles.body14DarkRegular.copyWith(
                fontWeight: FontWeight.w700,
                color: scheme.onSurface,
              ),
              priceStyle: AppTextStyles.body16DarkRegular.copyWith(
                color: dark ? scheme.primary : const Color(0xFF08A865),
                fontWeight: FontWeight.w800,
              ),
              trailing: Material(
                color: scheme.primary,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onAdd == null ? null : () => onAdd!(meal),
                  child: const SizedBox(
                    width: 33,
                    height: 33,
                    child: Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 21,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
