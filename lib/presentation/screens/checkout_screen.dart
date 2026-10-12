import 'package:flutter/material.dart';
import 'package:food_delivery/presentation/screens/add_card_screen.dart';
import 'package:food_delivery/presentation/screens/tracking_screen.dart';
import 'package:food_delivery/presentation/widgets/custom_button.dart';

import '../widgets/ui_parts.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String delivery = 'Standard', payment = 'Cash on Delivery';
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Checkout')),
    bottomNavigationBar: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: CustomButton(
          text: 'Place Order',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TrackingScreen()),
          ),
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
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddCardScreen()),
          ),
          icon: const Icon(Icons.credit_card),
          label: const Text('Add Card'),
        ),
        const SectionHeading('Order Summary'),
        const ListTile(title: Text('Subtotal'), trailing: Text('\$26.97')),
        const ListTile(title: Text('Delivery Fee'), trailing: Text('\$2.99')),
      ],
    ),
  );
}
