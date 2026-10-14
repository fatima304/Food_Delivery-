import '../widgets/app_back_button.dart';

import 'package:food_delivery/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/l10n/app_localizations.dart';
import 'package:food_delivery/presentation/widgets/custom_button.dart';

class EmptyCartScreen extends StatelessWidget {
  const EmptyCartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(leading: const AppBackButton(), title: Text(l10n.myCart)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.shopping_cart_outlined, size: 90),
              Text(l10n.yourCartEmpty, style: const TextStyle(fontSize: 22)),
              const SizedBox(height: 12),
              Text(l10n.addMealsToGetStarted),
              const SizedBox(height: 25),
              CustomButton(
                text: l10n.browseMeals,
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, Routes.home),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
