import 'package:food_delivery/core/helper/localized_state_error.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery/l10n/app_localizations.dart';

import '../../data/models/meal_model.dart';
import '../../injection.dart';
import '../blocs/search_cubit.dart';
import '../blocs/search_state.dart';
import '../widgets/app_nav.dart';
import 'meal_details_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<SearchCubit>()..load(),
    child: const _SearchContent(),
  );
}

class _SearchContent extends StatefulWidget {
  const _SearchContent();

  @override
  State<_SearchContent> createState() => _SearchContentState();
}

class _SearchContentState extends State<_SearchContent> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) context.read<SearchCubit>().search(value);
    });
  }

  void _chooseCategory(String category) {
    _debounce?.cancel();
    _controller.clear();
    FocusScope.of(context).unfocus();
    context.read<SearchCubit>().selectCategory(category);
  }

  void _openMeal(MealModel meal) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MealDetailsScreen(mealId: meal.id, initialMeal: meal),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.exploreMealsTitle)),
      bottomNavigationBar: const AppNav(index: 1),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) => RefreshIndicator(
          onRefresh: () async {
            _controller.clear();
            _debounce?.cancel();
            await context.read<SearchCubit>().load();
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    TextField(
                      controller: _controller,
                      onChanged: _onQueryChanged,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        _debounce?.cancel();
                        context.read<SearchCubit>().search(value);
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search_rounded),
                        hintText: l10n.searchMealsHint,
                        filled: true,
                        fillColor: colors.surfaceContainerLow,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: _controller.text.isEmpty
                            ? null
                            : IconButton(
                                icon: const Icon(Icons.close_rounded),
                                onPressed: () {
                                  _debounce?.cancel();
                                  _controller.clear();
                                  setState(() {});
                                  context.read<SearchCubit>().load();
                                },
                              ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      l10n.popularCategories,
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    if (state.categories.isNotEmpty)
                      SizedBox(
                        height: 110,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.categories.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            final category = state.categories[index];
                            final selected =
                                state.selectedCategory == category.name;
                            return InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () => _chooseCategory(category.name),
                              child: Container(
                                width: 104,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? colors.primaryContainer
                                      : colors.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Image.network(
                                        category.imageUrl,
                                        fit: BoxFit.contain,
                                        errorBuilder: (_, _, _) => Icon(
                                          Icons.restaurant,
                                          color: colors.primary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      category.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            state.selectedCategory != null
                                ? '${state.selectedCategory} ${l10n.categoryMeals}'
                                : state.query.isNotEmpty
                                ? '${l10n.resultsFor} "${state.query}"'
                                : l10n.recommendedForYou,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (state.loading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    if (state.error != null)
                      Center(
                        child: Column(
                          children: [
                            const Icon(Icons.wifi_off_rounded, size: 44),
                            const SizedBox(height: 8),
                            Text(
                              localizedStateError(context, state.error),
                              textAlign: TextAlign.center,
                            ),
                            TextButton.icon(
                              onPressed: () {
                                if (state.selectedCategory != null) {
                                  context.read<SearchCubit>().selectCategory(
                                    state.selectedCategory!,
                                  );
                                } else if (state.query.isNotEmpty) {
                                  context.read<SearchCubit>().search(
                                    state.query,
                                  );
                                } else {
                                  context.read<SearchCubit>().load();
                                }
                              },
                              icon: const Icon(Icons.refresh),
                              label: Text(l10n.tryAgain),
                            ),
                          ],
                        ),
                      ),
                    if (!state.loading &&
                        state.error == null &&
                        state.meals.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: Column(
                            children: [
                              const Icon(Icons.search_off_rounded, size: 56),
                              const SizedBox(height: 8),
                              Text(l10n.noMealsSearch),
                            ],
                          ),
                        ),
                      ),
                  ]),
                ),
              ),
              if (!state.loading &&
                  state.error == null &&
                  state.meals.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
                  sliver: SliverLayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.crossAxisExtent;
                      return SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: width >= 650 ? 3 : 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: .77,
                        ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final meal = state.meals[index];
                          return _SearchMealCard(
                            meal: meal,
                            onTap: () => _openMeal(meal),
                          );
                        }, childCount: state.meals.length),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchMealCard extends StatelessWidget {
  const _SearchMealCard({required this.meal, required this.onTap});
  final MealModel meal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      color: colors.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.network(
                meal.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Icon(
                  Icons.restaurant_menu,
                  size: 42,
                  color: colors.primary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    meal.category ?? l10n.meal,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '\$${meal.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
