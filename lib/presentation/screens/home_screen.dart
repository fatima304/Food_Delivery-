import 'package:food_delivery/core/helper/localized_state_error.dart';

import '../blocs/cart_bloc.dart';
import '../blocs/cart_event.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery/l10n/app_localizations.dart';

import '../../injection.dart';
import '../blocs/home_cubit.dart';
import '../blocs/home_state.dart';
import '../widgets/app_nav.dart';
import '../widgets/home_categories.dart';
import '../widgets/home_meal_card.dart';
import '../widgets/ui_parts.dart';
import 'search_screen.dart';
import 'meal_details_screen.dart';
import 'nearby_vendors_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<HomeCubit>()..load(),
    child: const _HomeContent(),
  );
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      bottomNavigationBar: const AppNav(index: 0),
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) => RefreshIndicator(
            onRefresh: () => context.read<HomeCubit>().load(),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              children: [
                SizedBox(height: 20),
                Material(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(18),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 5,
                    ),
                    leading: Icon(
                      Icons.map_outlined,
                      color: colors.primary,
                      size: 30,
                    ),
                    title: Text(
                      l10n.nearbyVendors,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(l10n.nearbyVendorsSubtitle),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: colors.primary,
                      size: 18,
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NearbyVendorsScreen(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  readOnly: true,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SearchScreen()),
                  ),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: l10n.searchHint,
                    filled: true,
                    fillColor: colors.surfaceContainerLow,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                SizedBox(
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
                ),
                SectionHeading(l10n.categories),
                HomeCategories(
                  categories: state.categories,
                  selected: state.selectedCategory,
                  onSelected: context.read<HomeCubit>().selectCategory,
                ),
                SectionHeading(l10n.hotOffers),
                SizedBox(
                  height: 130,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.offers.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, i) => SizedBox(
                      width: 145,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              state.offers[i].imageUrl,
                              width: 145,
                              height: 90,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) =>
                                  const FoodPhoto(height: 90),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            state.offers[i].name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SectionHeading(l10n.popularMeals),
                if (state.loading)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                if (state.error != null)
                  Column(
                    children: [
                      Text(
                        localizedStateError(context, state.error),
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                        onPressed: () => state.selectedCategory == null
                            ? context.read<HomeCubit>().load()
                            : context.read<HomeCubit>().selectCategory(
                                state.selectedCategory,
                              ),
                        child: Text(l10n.tryAgain),
                      ),
                    ],
                  ),
                if (!state.loading &&
                    state.error == null &&
                    state.meals.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(l10n.noMealsFound),
                    ),
                  ),
                if (state.meals.isNotEmpty)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.meals.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: .87,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemBuilder: (context, i) => GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MealDetailsScreen(
                            mealId: state.meals[i].id,
                            initialMeal: state.meals[i],
                          ),
                        ),
                      ),
                      child: HomeMealCard(
                        meal: state.meals[i],
                        onAdd: (meal) {
                          context.read<CartBloc>().add(CartAdd(meal));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${l10n.addedToCart} ${meal.name}'),
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
