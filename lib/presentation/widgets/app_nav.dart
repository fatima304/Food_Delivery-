import 'package:flutter/cupertino.dart';
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
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return BottomNavigationBar(
      currentIndex: index,
      type: BottomNavigationBarType.fixed,
      backgroundColor: colors.surface,
      selectedItemColor: colors.primary,
      unselectedItemColor: colors.onSurfaceVariant,
      selectedFontSize: 11,
      unselectedFontSize: 11,
      elevation: 0,
      showUnselectedLabels: true,
      onTap: (i) {
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
      items: const [
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.house),
          activeIcon: Icon(CupertinoIcons.house_fill),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.search),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.cart),
          activeIcon: Icon(CupertinoIcons.cart_fill),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.doc_text),
          activeIcon: Icon(CupertinoIcons.doc_text_fill),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.person),
          activeIcon: Icon(CupertinoIcons.person_fill),
          label: 'Profile',
        ),
      ],
    );
  }
}
