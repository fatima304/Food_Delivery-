import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../injection.dart';
import '../../data/repositories/orders_repository.dart';
import '../../domain/repositories/payment_method.dart';
import '../blocs/cart_bloc.dart';
import '../blocs/cart_event.dart';
import '../blocs/cart_state.dart';
import 'orders_screen.dart';
import 'package:food_delivery/presentation/widgets/custom_button.dart';
import '../widgets/ui_parts.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String delivery = 'Standard', payment = 'Cash on Delivery';
  bool placing = false;

  Future<void> _placeOrder() async {
    if (placing) return;
    final cart = context.read<CartBloc>();
    final state = cart.state;
    if (state.items.isEmpty) return;
    setState(() => placing = true);
    try {
      await cart.waitForWrites();
      await getIt<OrdersRepository>().placeOrder(
        items: state.items, subtotal: state.subtotal,
        deliveryFee: state.deliveryFee, deliveryTime: delivery,
        payment: payment == 'Cash on Delivery'
            ? const CashPayment() : const CardPayment(),
      );
      cart.add(const CartClear());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order placed successfully!')),
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const OrdersScreen()),
        (route) => route.isFirst,
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Could not place your order. Please try again.'),
      ));
    } finally {
      if (mounted) setState(() => placing = false);
    }
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Checkout')),
    bottomNavigationBar: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: CustomButton(
          text: placing ? 'Placing Order...' : 'Place Order',
          onPressed: placing ? null : _placeOrder,
        ),
      ),
    ),
    body: ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const FoodPhoto(height: 140),
        const SectionHeading('Delivery Address'),
        const ListTile(
          leading: Icon(Icons.location_on_outlined),
          title: Text('Home'),
          subtitle: Text('Park Way 145, Maadi, Cairo'),
        ),
        const SectionHeading('Delivery Time'),
        for (final option in ['Express', 'Standard'])
          RadioListTile<String>(
            title: Text(option),
            value: option,
            groupValue: delivery,
            onChanged: (v) => setState(() => delivery = v!),
          ),
        const SectionHeading('Payment Method'),
        for (final option in ['Cash on Delivery', 'Credit / Debit Card'])
          RadioListTile<String>(
            title: Text(option),
            value: option,
            groupValue: payment,
            onChanged: (v) => setState(() => payment = v!),
          ),
        TextButton.icon(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Card payment is a demo. Do not enter real card details.')),
          ),
          icon: const Icon(Icons.credit_card),
          label: const Text('Add Card'),
        ),
        const SectionHeading('Order Summary'),
        BlocBuilder<CartBloc, CartState>(builder: (_, cart) => Column(children: [
          ListTile(title: const Text('Subtotal'), trailing: Text('\$${cart.subtotal.toStringAsFixed(2)}')),
          ListTile(title: const Text('Delivery Fee'), trailing: Text('\$${cart.deliveryFee.toStringAsFixed(2)}')),
          ListTile(title: const Text('Total'), trailing: Text('\$${cart.total.toStringAsFixed(2)}')),
        ])),
      ],
    ),
  );
}
