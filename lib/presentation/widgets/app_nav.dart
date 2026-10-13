import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/cart_bloc.dart';
import '../blocs/cart_state.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
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
      items: [
        BottomNavigationBarItem(
          icon: const Icon(CupertinoIcons.house),
          activeIcon: const Icon(CupertinoIcons.house_fill),
          label: l10n.home,
        ),
        BottomNavigationBarItem(
          icon: const Icon(CupertinoIcons.search),
          label: l10n.explore,
        ),
        BottomNavigationBarItem(
          icon: const _CartBadge(icon: CupertinoIcons.cart),
          activeIcon: const _CartBadge(icon: CupertinoIcons.cart_fill),
          label: l10n.cart,
        ),
        BottomNavigationBarItem(
          icon: const Icon(CupertinoIcons.doc_text),
          activeIcon: const Icon(CupertinoIcons.doc_text_fill),
          label: l10n.orders,
        ),
        BottomNavigationBarItem(
          icon: const Icon(CupertinoIcons.person),
          activeIcon: const Icon(CupertinoIcons.person_fill),
          label: l10n.profile,
        ),
      ],
    );
  }
}

class _CartBadge extends StatelessWidget {
  const _CartBadge({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) => BlocBuilder<CartBloc, CartState>(
    builder: (context, state) => Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon),
        if (state.count > 0)
          Positioned(
            top: -7,
            right: -11,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              constraints: const BoxConstraints(minWidth: 17, minHeight: 17),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                state.count > 99 ? '99+' : '${state.count}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onError,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
