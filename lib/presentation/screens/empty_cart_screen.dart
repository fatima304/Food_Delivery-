import 'package:flutter/material.dart';
import 'package:food_delivery/presentation/widgets/custom_button.dart';

import 'home_screen.dart';

class EmptyCartScreen extends StatelessWidget {
  const EmptyCartScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('My Cart')),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shopping_cart_outlined, size: 90),
            const Text('Your cart is empty', style: TextStyle(fontSize: 22)),
            const SizedBox(height: 12),
            const Text('Add some delicious meals and get started!'),
            const SizedBox(height: 25),
            CustomButton(
              text: 'Browse Meals',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
