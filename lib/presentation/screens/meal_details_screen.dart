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
  bool isDescriptionExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final green = colors.primary;
    final muted = colors.onSurfaceVariant;
    final l10n = AppLocalizations.of(context)!;

    final titleStyle = AppTextStyles.heading24BlackBold.copyWith(
      color: colors.onSurface,
      fontSize: 19,
      height: 1.2,
    );

    return BlocBuilder<FavouritesCubit, FavouritesState>(
      builder: (context, favourites) => BlocConsumer<MealDetailsCubit, MealDetailsState>(
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
                ? SafeArea(
                    child: Column(
                      children: [
                        _topBar(context, titleStyle, l10n),
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
                                          color: muted,
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          state.error == null
                                              ? l10n.mealNotFound
                                              : localizedStateError(
                                                  context,
                                                  state.error,
                                                ),
                                          textAlign: TextAlign.center,
                                          style: AppTextStyles.body16GreyRegular
                                              .copyWith(color: muted),
                                        ),
                                        const SizedBox(height: 12),
                                        TextButton.icon(
                                          onPressed: () => context
                                              .read<MealDetailsCubit>()
                                              .load(widget.mealId),
                                          icon: const Icon(
                                            Icons.refresh_rounded,
                                          ),
                                          label: Text(l10n.tryAgain),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  )
                : SafeArea(
                    child: Column(
                      children: [
                        _topBar(context, titleStyle, l10n),
                        Expanded(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final imageHeight = (constraints.maxWidth * .79)
                                  .clamp(230.0, 350.0);

                              return SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Stack(
                                      children: [
                                        Image.network(
                                          meal.imageUrl,
                                          height: imageHeight,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, _, _) => Container(
                                            height: imageHeight,
                                            color: colors.surfaceContainerLow,
                                            child: Icon(
                                              Icons.restaurant_menu_rounded,
                                              size: 66,
                                              color: green,
                                            ),
                                          ),
                                        ),
                                        PositionedDirectional(
                                          top: 16,
                                          start: 18,
                                          child: _roundIcon(
                                            context,
                                            Icons.arrow_back_ios_new_rounded,
                                            () =>
                                                Navigator.of(context)
                                                    .maybePop(),
                                          ),
                                        ),
                                        PositionedDirectional(
                                          top: 16,
                                          end: 18,
                                          child: _roundIcon(
                                            context,
                                            favorite
                                                ? Icons.favorite_rounded
                                                : Icons.favorite_border_rounded,
                                            () => context
                                                .read<FavouritesCubit>()
                                                .toggle(meal),
                                            iconColor: favorite
                                                ? colors.error
                                                : colors.onSurface,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Transform.translate(
                                      offset: const Offset(0, -18),
                                      child: Container(
                                        padding: const EdgeInsets.fromLTRB(
                                          20,
                                          22,
                                          20,
                                          20,
                                        ),
                                        decoration: BoxDecoration(
                                          color: colors.surface,
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                top: Radius.circular(24),
                                              ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    meal.name,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: AppTextStyles
                                                        .heading24BlackBold
                                                        .copyWith(
                                                          fontSize: 23,
                                                          color:
                                                              colors.onSurface,
                                                          height: 1.25,
                                                        ),
                                                  ),
                                                ),
                                                IconButton(
                                                  padding: EdgeInsets.zero,
                                                  constraints:
                                                      const BoxConstraints(
                                                        minWidth: 36,
                                                        minHeight: 36,
                                                      ),
                                                  onPressed: () => context
                                                      .read<FavouritesCubit>()
                                                      .toggle(meal),
                                                  icon: Icon(
                                                    favorite
                                                        ? Icons.favorite_rounded
                                                        : Icons
                                                              .favorite_border_rounded,
                                                    color: favorite
                                                        ? colors.error
                                                        : muted,
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
                                                  style: AppTextStyles
                                                      .heading24BlackBold
                                                      .copyWith(
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
                                                  style: AppTextStyles
                                                      .body14GreyRegular
                                                      .copyWith(color: muted),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 17),
                                            Wrap(
                                              spacing: 18,
                                              runSpacing: 8,
                                              children: [
                                                _info(
                                                  Icons.verified_outlined,
                                                  l10n.fresh,
                                                  green,
                                                  muted,
                                                ),
                                                if (meal.category?.isNotEmpty ==
                                                    true)
                                                  _info(
                                                    Icons
                                                        .restaurant_menu_outlined,
                                                    meal.category!,
                                                    green,
                                                    muted,
                                                  ),
                                                if (meal.area?.isNotEmpty ==
                                                    true)
                                                  _info(
                                                    Icons.public_rounded,
                                                    meal.area!,
                                                    green,
                                                    muted,
                                                  ),
                                              ],
                                            ),
                                            const SizedBox(height: 22),

                                            // Category
                                            if (meal.category?.isNotEmpty ==
                                                true) ...[
                                              _sectionTitle(
                                                l10n.category,
                                                colors.onSurface,
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                meal.category!,
                                                style: AppTextStyles
                                                    .body14GreyRegular
                                                    .copyWith(color: muted),
                                              ),
                                              const SizedBox(height: 18),
                                            ],

                                            // Origin
                                            if (meal.area?.isNotEmpty ==
                                                true) ...[
                                              _sectionTitle(
                                                l10n.origin,
                                                colors.onSurface,
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                meal.area!,
                                                style: AppTextStyles
                                                    .body14GreyRegular
                                                    .copyWith(color: muted),
                                              ),
                                              const SizedBox(height: 22),
                                            ],

                                            // Description
                                            _sectionTitle(
                                              l10n.description,
                                              colors.onSurface,
                                            ),
                                            const SizedBox(height: 8),

                                            _buildDescription(
                                              meal.instructions
                                                          ?.trim()
                                                          .isNotEmpty ==
                                                      true
                                                  ? meal.instructions!.trim()
                                                  : l10n.noDescription,
                                              muted,
                                              green,
                                              l10n,
                                            ),

                                            if (state.loading) ...[
                                              const SizedBox(height: 15),
                                              const LinearProgressIndicator(
                                                minHeight: 2,
                                              ),
                                            ],

                                            const SizedBox(height: 25),

                                            // Quantity & Add to Cart
                                            Row(
                                              children: [
                                                Container(
                                                  height: 46,
                                                  decoration: BoxDecoration(
                                                    color: colors.surface,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          14,
                                                        ),
                                                    border: Border.all(
                                                      color: colors
                                                          .outlineVariant
                                                          .withValues(
                                                            alpha: .55,
                                                          ),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      _quantityButton(
                                                        Icons.remove_rounded,
                                                        quantity > 1
                                                            ? () => setState(
                                                                () =>
                                                                    quantity--,
                                                              )
                                                            : null,
                                                        muted,
                                                      ),
                                                      Text(
                                                        '$quantity',
                                                        style: AppTextStyles
                                                            .body16DarkRegular
                                                            .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: colors
                                                                  .onSurface,
                                                            ),
                                                      ),
                                                      _quantityButton(
                                                        Icons.add_rounded,
                                                        () => setState(
                                                          () => quantity++,
                                                        ),
                                                        colors.onSurface,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: SizedBox(
                                                    height: 46,
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        context
                                                            .read<CartBloc>()
                                                            .add(
                                                              CartAdd(
                                                                meal,
                                                                quantity:
                                                                    quantity,
                                                              ),
                                                            );
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              '$quantity x ${meal.name} ${l10n.addedToCartQuantity}',
                                                            ),
                                                            behavior:
                                                                SnackBarBehavior
                                                                    .floating,
                                                          ),
                                                        );
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: green,
                                                        foregroundColor:
                                                            colors.onPrimary,
                                                        elevation: 0,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                14,
                                                              ),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        l10n.addToCart,
                                                        style: AppTextStyles
                                                            .button16WhiteSemiBold
                                                            .copyWith(
                                                              color: colors
                                                                  .onPrimary,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }

  // Expandable Description
  Widget _buildDescription(
    String description,
    Color muted,
    Color green,
    AppLocalizations l10n,
  ) {
    final descriptionStyle = AppTextStyles.body14GreyRegular.copyWith(
      color: muted,
      height: 1.6,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final textPainter = TextPainter(
          text: TextSpan(text: description, style: descriptionStyle),
          maxLines: 4,
          textDirection: Directionality.of(context),
        )..layout(maxWidth: constraints.maxWidth);

        final hasMoreText = textPainter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              description,
              maxLines: isDescriptionExpanded ? null : 4,
              overflow: isDescriptionExpanded
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,
              style: descriptionStyle,
            ),
            if (hasMoreText) ...[
              const SizedBox(height: 6),
              InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: () {
                  setState(() {
                    isDescriptionExpanded = !isDescriptionExpanded;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isDescriptionExpanded ? l10n.seeLess : l10n.seeMore,
                        style: AppTextStyles.body14GreyRegular.copyWith(
                          color: green,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        isDescriptionExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        size: 20,
                        color: green,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _topBar(
    BuildContext context,
    TextStyle titleStyle,
    AppLocalizations l10n,
  ) => SizedBox(
    height: 48,
    child: Center(child: Text(l10n.mealDetails, style: titleStyle)),
  );

  Widget _roundIcon(
    BuildContext context,
    IconData icon,
    VoidCallback onTap, {
    Color? iconColor,
  }) {
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

  Widget _info(IconData icon, String text, Color green, Color muted) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 15, color: green),
      const SizedBox(width: 5),
      Text(
        text,
        style: AppTextStyles.body14GreyRegular.copyWith(
          color: muted,
          fontSize: 12,
        ),
      ),
    ],
  );

  Widget _sectionTitle(String title, Color color) => Text(
    title,
    style: AppTextStyles.body16DarkRegular.copyWith(
      color: color,
      fontWeight: FontWeight.w700,
      fontSize: 15,
    ),
  );

  Widget _quantityButton(IconData icon, VoidCallback? onTap, Color color) =>
      IconButton(
        onPressed: onTap,
        icon: Icon(icon, size: 18, color: color),
        constraints: const BoxConstraints(minWidth: 35, minHeight: 42),
        padding: EdgeInsets.zero,
      );
}
