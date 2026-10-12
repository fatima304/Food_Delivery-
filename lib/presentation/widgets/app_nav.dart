import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/search_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/profile_screen.dart';

class AppNav extends StatelessWidget {
  const AppNav({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) => NavigationBar(
    selectedIndex: index,
    height: 66,
    onDestinationSelected: (i) {
      if (i == index) return;
      final screens = [
        const HomeScreen(),
        const SearchScreen(),
        const CartScreen(),
        const OrdersScreen(),
        const ProfileScreen(),
      ];
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => screens[i]));
    },
    destinations: const [
      NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
      NavigationDestination(icon: Icon(Icons.search), label: 'Explore'),
      NavigationDestination(
        icon: Icon(Icons.shopping_cart_outlined),
        label: 'Cart',
      ),
      NavigationDestination(
        icon: Icon(Icons.receipt_long_outlined),
        label: 'Orders',
      ),
      NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
    ],
  );
}
