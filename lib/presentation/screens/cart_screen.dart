import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery/l10n/app_localizations.dart';
import 'package:food_delivery/presentation/screens/checkout_screen.dart';
import 'package:food_delivery/presentation/widgets/custom_button.dart';

import '../blocs/cart_bloc.dart';
import '../blocs/cart_event.dart';
import '../blocs/cart_state.dart';
import '../widgets/app_nav.dart';
import '../widgets/empty_cart_view.dart';
import 'home_screen.dart';
import '../widgets/ui_parts.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<CartBloc, CartState>(
      listenWhen: (previous, current) =>
          previous.items.isNotEmpty && current.items.isEmpty,
      listener: (context, state) => showDemo(context, l10n.yourCartEmpty),
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.myCart)),
        bottomNavigationBar: const AppNav(index: 2),
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (!state.loading && state.items.isEmpty) {
              return EmptyCartView(
                onBrowseMeals: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                ),
              );
            }
            return ListView(
              padding: const EdgeInsets.all(18),
              children: [
                if (state.loading)
                  const Center(child: CircularProgressIndicator()),
                for (final item in state.items)
                  UiCard(
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            item.meal.imageUrl,
                            width: 72,
                            height: 72,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const FoodPhoto(width: 72, height: 72),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.meal.name, maxLines: 2),
                              Text('\$${item.meal.price.toStringAsFixed(2)}'),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => context.read<CartBloc>().add(
                            CartDecrease(item.meal.id),
                          ),
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                        Text('${item.quantity}'),
                        IconButton(
                          onPressed: () => context.read<CartBloc>().add(
                            CartIncrease(item.meal.id),
                          ),
                          icon: const Icon(Icons.add_circle_outline),
                        ),
                      ],
                    ),
                  ),
                SectionHeading(l10n.orderSummary),
                ListTile(
                  title: Text(l10n.subtotal),
                  trailing: Text('\$${state.subtotal.toStringAsFixed(2)}'),
                ),
                ListTile(
                  title: Text(l10n.deliveryFee),
                  trailing: Text('\$${state.deliveryFee.toStringAsFixed(2)}'),
                ),
                ListTile(
                  title: Text(
                    l10n.total,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Text('\$${state.total.toStringAsFixed(2)}'),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: l10n.proceedToCheckout,
                  onPressed: state.loading || state.items.isEmpty
                      ? null
                      : () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CheckoutScreen(),
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
