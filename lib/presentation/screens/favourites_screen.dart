import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/favourites_cubit.dart';
import 'meal_details_screen.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Favourites')),
    body: BlocBuilder<FavouritesCubit, FavouritesState>(
      builder: (context, state) {
        if (state.loading) return const Center(child: CircularProgressIndicator());
        if (state.error != null && state.meals.isEmpty) {
          return Center(child: Text(state.error!, textAlign: TextAlign.center));
        }
        if (state.meals.isEmpty) {
          return const Center(child: Text('No favourites yet. Tap a heart to save a meal.'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(18),
          itemCount: state.meals.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final meal = state.meals[index];
            return Card(
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(meal.imageUrl, width: 64, height: 64,
                    fit: BoxFit.cover, errorBuilder: (_, __, ___) =>
                      const SizedBox(width: 64, child: Icon(Icons.restaurant))),
                ),
                title: Text(meal.name, maxLines: 2, overflow: TextOverflow.ellipsis),
                subtitle: Text('\$${meal.price.toStringAsFixed(2)}'),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite_rounded, color: Colors.red),
                  onPressed: () => context.read<FavouritesCubit>().toggle(meal),
                ),
                onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (_) => MealDetailsScreen(mealId: meal.id, initialMeal: meal))),
              ),
            );
          },
        );
      },
    ),
  );
}
