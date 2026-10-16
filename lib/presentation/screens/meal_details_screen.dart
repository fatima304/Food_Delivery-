import 'package:food_delivery/core/helper/localized_state_error.dart';

import '../blocs/favourites_cubit.dart';
import '../blocs/cart_bloc.dart';
import '../blocs/cart_event.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery/l10n/app_localizations.dart';

import '../../core/style/app_text_styles.dart';
import '../../data/models/meal_model.dart';
import '../blocs/meal_details_cubit.dart';
import '../blocs/meal_details_state.dart';
import '../widgets/meal_details/meal_details_top_bar.dart';
import '../widgets/meal_details/meal_details_image_section.dart';
import '../widgets/meal_details/meal_details_info_section.dart';
import '../widgets/meal_details/meal_details_description.dart';
import '../widgets/meal_details/meal_details_quantity_section.dart';
import '../widgets/meal_details/section_title.dart';

class MealDetailsScreen extends StatelessWidget {
  const MealDetailsScreen({super.key, required this.mealId, this.initialMeal});

  final String mealId;
  final MealModel? initialMeal;

  @override
  Widget build(BuildContext context) =>
      _MealDetailsContent(mealId: mealId, initialMeal: initialMeal);
}

class _MealDetailsContent extends StatefulWidget {
  const _MealDetailsContent({required this.mealId, this.initialMeal});

  final String mealId;
  final MealModel? initialMeal;

  @override
  State<_MealDetailsContent> createState() => _MealDetailsContentState();
}

class _MealDetailsContentState extends State<_MealDetailsContent> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<FavouritesCubit, FavouritesState>(
      builder: (context, favourites) =>
          BlocConsumer<MealDetailsCubit, MealDetailsState>(
            listenWhen: (previous, current) =>
                current.error != null &&
                current.meal != null &&
                (previous.error != current.error || previous.loading),
            listener: (context, state) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(localizedStateError(context, state.error)),
                  behavior: SnackBarBehavior.floating,
                  action: SnackBarAction(
                    label: AppLocalizations.of(context)!.tryAgain,
                    onPressed: () =>
                        context.read<MealDetailsCubit>().load(widget.mealId),
                  ),
                ),
              );
            },
            builder: (context, state) {
              final meal = state.meal ?? widget.initialMeal;
              final favorite = favourites.contains(widget.mealId);

              return Scaffold(
                backgroundColor: colors.surface,
                body: meal == null
                    ? _buildLoadingError(colors, l10n, state)
                    : _buildMealContent(colors, l10n, state, meal, favorite),
              );
            },
          ),
    );
  }

  Widget _buildLoadingError(
    ColorScheme colors,
    AppLocalizations l10n,
    MealDetailsState state,
  ) {
    return SafeArea(
      child: Column(
        children: [
          const MealDetailsTopBar(),
          Expanded(
            child: Center(
              child: state.loading
                  ? const CircularProgressIndicator()
                  : Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.restaurant_menu_rounded,
                            size: 48,
                            color: colors.onSurfaceVariant,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            state.error == null
                                ? l10n.mealNotFound
                                : localizedStateError(context, state.error),
                            textAlign: TextAlign.center,
                            style: AppTextStyles.body16GreyRegular.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextButton.icon(
                            onPressed: () => context
                                .read<MealDetailsCubit>()
                                .load(widget.mealId),
                            icon: const Icon(Icons.refresh_rounded),
                            label: Text(l10n.tryAgain),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealContent(
    ColorScheme colors,
    AppLocalizations l10n,
    MealDetailsState state,
    MealModel meal,
    bool favorite,
  ) {
    return SafeArea(
      child: Column(
        children: [
          const MealDetailsTopBar(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final imageHeight = (constraints.maxWidth * .79).clamp(
                  230.0,
                  350.0,
                );

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MealDetailsImageSection(
                        meal: meal,
                        imageHeight: imageHeight,
                        onBack: () => Navigator.of(context).maybePop(),
                        onFavorite: () =>
                            context.read<FavouritesCubit>().toggle(meal),
                        isFavorite: favorite,
                      ),
                      MealDetailsInfoSection(
                        meal: meal,
                        isFavorite: favorite,
                        onFavorite: () =>
                            context.read<FavouritesCubit>().toggle(meal),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: _buildDescriptionSection(colors, l10n, meal),
                      ),
                      if (meal.ingredients.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 20, 18, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SectionTitle(
                                title: l10n.ingredients,
                                color: colors.onSurface,
                              ),
                              const SizedBox(height: 10),
                              ...meal.ingredients.map(
                                (item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 7),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle_outline_rounded,
                                        size: 17,
                                        color: colors.primary,
                                      ),
                                      const SizedBox(width: 9),
                                      Expanded(child: Text(item)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (state.loading) ...[
                        const SizedBox(height: 15),
                        const LinearProgressIndicator(minHeight: 2),
                      ],
                      const SizedBox(height: 25),
                      MealDetailsQuantitySection(
                        meal: meal,
                        quantity: quantity,
                        onQuantityChanged: (newQuantity) {
                          setState(() => quantity = newQuantity);
                        },
                        onAddToCart: () {
                          context.read<CartBloc>().add(
                            CartAdd(meal, quantity: quantity),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '$quantity x ${meal.name} ${l10n.addedToCartQuantity}',
                              ),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(
    ColorScheme colors,
    AppLocalizations l10n,
    MealModel meal,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: l10n.description, color: colors.onSurface),
        const SizedBox(height: 8),
        MealDetailsDescription(
          description: meal.instructions?.trim().isNotEmpty == true
              ? meal.instructions!.trim()
              : l10n.noDescription,
        ),
      ],
    );
  }
}
