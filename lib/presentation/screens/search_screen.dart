import 'package:food_delivery/core/routing/routes.dart';
import 'package:food_delivery/core/routing/app_router.dart';
import 'package:food_delivery/core/helper/localized_state_error.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery/l10n/app_localizations.dart';

import '../../data/models/meal_model.dart';
import '../blocs/search_cubit.dart';
import '../blocs/search_state.dart';
import '../../core/widgets/app_nav.dart';
import '../widgets/search/search_meal_card.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) => const _SearchContent();
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
    Navigator.pushNamed(
      context,
      Routes.mealDetails,
      arguments: MealDetailsArgs(mealId: meal.id, initialMeal: meal),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(l10n.exploreMealsTitle),
      ),
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
                        height: 105,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.categories.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final category = state.categories[index];
                            final selected =
                                state.selectedCategory == category.name;

                            return Material(
                              color: selected
                                  ? colors.primaryContainer
                                  : colors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(16),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () => _chooseCategory(category.name),
                                child: Container(
                                  width: 105,
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Colors.transparent,
                                        backgroundImage: NetworkImage(
                                          category.imageUrl,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        category.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: colors.onSurface,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                    if (state.query.isNotEmpty ||
                        state.selectedCategory != null ||
                        state.selectedArea != null) ...[
                      const SizedBox(height: 24),
                      Text(
                        state.selectedCategory != null
                            ? '${state.selectedCategory} ${l10n.categoryMeals}'
                            : state.selectedArea != null
                            ? '${state.selectedArea} ${l10n.categoryMeals}'
                            : '${l10n.resultsFor} "${state.query}"',
                        style: Theme.of(context).textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                    ],
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
                                } else if (state.selectedArea != null) {
                                  context.read<SearchCubit>().selectArea(
                                    state.selectedArea!,
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
                        (state.query.isNotEmpty ||
                            state.selectedCategory != null ||
                            state.selectedArea != null) &&
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
                  (state.query.isNotEmpty ||
                      state.selectedCategory != null ||
                      state.selectedArea != null) &&
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
                          return SearchMealCard(
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
