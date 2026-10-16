import 'package:flutter/material.dart';
import 'package:food_delivery/data/models/meal_model.dart';
import 'package:food_delivery/core/widgets/ui_parts.dart';

class HotOffersList extends StatelessWidget {
  const HotOffersList({super.key, required this.offers});

  final List<MealModel> offers;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: offers.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, i) => SizedBox(
          width: 145,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  offers[i].imageUrl,
                  width: 145,
                  height: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const FoodPhoto(height: 90),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                offers[i].name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
