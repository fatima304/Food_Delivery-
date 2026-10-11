import 'package:flutter/material.dart';
import 'package:food_delivery/presentation/screens/login_screen.dart';

void main() => runApp(const FoodDeliveryApp());

class FoodDeliveryApp extends StatelessWidget {
  const FoodDeliveryApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Delivery',
      theme: ThemeData(useMaterial3: true),
      home: const LoginScreen(),
    );
  }
}
