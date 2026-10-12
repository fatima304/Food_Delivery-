import 'package:flutter/material.dart';
import 'package:food_delivery/presentation/screens/checkout_screen.dart';
import 'package:food_delivery/presentation/widgets/custom_button.dart';

import '../widgets/app_nav.dart';
import '../widgets/ui_parts.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final items = <String, int>{
    'Grilled Chicken Salad': 1,
    'Margherita Pizza': 1,
    'Cheese Burger': 2,
  };
  @override
  Widget build(BuildContext context) {
    final total = items.values.fold<int>(0, (a, b) => a + b) * 6.50;
    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      bottomNavigationBar: const AppNav(index: 2),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          if (items.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(60),
                child: Column(
                  children: [
                    Icon(Icons.remove_shopping_cart_outlined, size: 64),
                    Text('Your cart is empty'),
                  ],
                ),
              ),
            ),
          for (final item in items.keys.toList())
            UiCard(
              child: Row(
                children: [
                  const FoodPhoto(width: 72, height: 72),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text(item, maxLines: 2), const Text('\$6.50')],
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() {
                      if (items[item]! > 1) {
                        items[item] = items[item]! - 1;
                      } else {
                        items.remove(item);
                        if (items.isEmpty)
                          showDemo(context, 'Your cart is empty');
                      }
                    }),
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Text('${items[item]}'),
                  IconButton(
                    onPressed: () =>
                        setState(() => items[item] = items[item]! + 1),
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
            ),
          const SectionHeading('Order Summary'),
          ListTile(
            title: const Text('Subtotal'),
            trailing: Text('\$${total.toStringAsFixed(2)}'),
          ),
          const ListTile(title: Text('Delivery Fee'), trailing: Text('\$2.99')),
          ListTile(
            title: const Text(
              'Total',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Text('\$${(total + 2.99).toStringAsFixed(2)}'),
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: 'Proceed to Checkout',
            onPressed: items.isEmpty
                ? null
                : () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                  ),
          ),
        ],
      ),
    );
  }
}
