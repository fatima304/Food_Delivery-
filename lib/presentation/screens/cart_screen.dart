import 'package:flutter/material.dart';

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
    return Scaffold(appBar: AppBar(title: const Text('My Cart')));
  }
}
