import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String delivery = 'Standard', payment = 'Cash on Delivery';
  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: const Text('Checkout')));
}
