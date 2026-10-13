import 'package:flutter/material.dart';
import 'package:food_delivery/core/constants/app_colors.dart';
import 'package:food_delivery/core/constants/app_images.dart';
import 'package:food_delivery/presentation/widgets/custom_button.dart';

/// Empty cart illustration and action; kept separate from cart business logic.
class EmptyCartView extends StatelessWidget {
  const EmptyCartView({super.key, required this.onBrowseMeals});

  final VoidCallback onBrowseMeals;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
               AppImages.emptyCart,
                width: 270,
                height: 230,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.remove_shopping_cart_outlined,
                  size: 115,
                  color: AppColors.textGrey,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Your cart is empty',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Add some delicious meals\nand get started!',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textGrey,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 30),
              CustomButton(
                text: 'Browse Meals',
                onPressed: onBrowseMeals,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
