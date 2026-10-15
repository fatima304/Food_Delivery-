import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery/core/routing/app_router.dart';
import 'package:food_delivery/core/routing/routes.dart';
import 'package:food_delivery/data/models/meal_model.dart';
import 'package:food_delivery/l10n/app_localizations.dart';
import 'package:food_delivery/presentation/blocs/cart_bloc.dart';
import 'package:food_delivery/presentation/blocs/cart_event.dart';
import 'package:food_delivery/presentation/widgets/home/home_meal_card.dart';

class PopularMealsGrid extends StatelessWidget {
  const PopularMealsGrid({super.key, required this.meals});

  final List<MealModel> meals;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: meals.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: .87,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, i) => GestureDetector(
        onTap: () => Navigator.pushNamed(
          context,
          Routes.mealDetails,
          arguments: MealDetailsArgs(
            mealId: meals[i].id,
            initialMeal: meals[i],
          ),
        ),
        child: HomeMealCard(
          meal: meals[i],
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
    );
  }
}
