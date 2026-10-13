import 'package:flutter/material.dart';

import '../widgets/app_nav.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_tile.dart';
import 'orders_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _comingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$feature is coming soon')));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: scheme.surface,
      ),
      bottomNavigationBar: const AppNav(index: 4),
      body: ListView(
        children: [
          ProfileHeader(onEdit: () => _comingSoon(context, 'Edit profile')),
          const SizedBox(height: 8),
          ProfileMenuTile(
            icon: Icons.favorite_border,
            title: 'Favourites',
            onTap: () => _comingSoon(context, 'Favourites'),
          ),
          ProfileMenuTile(
            icon: Icons.receipt_long_outlined,
            title: 'Order History',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OrdersScreen()),
            ),
          ),
          ProfileMenuTile(
            icon: Icons.settings_outlined,
            title: 'Settings',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
          ProfileMenuTile(
            icon: Icons.fingerprint,
            title: 'Biometric',
            onTap: () => _comingSoon(context, 'Biometric'),
          ),
          ProfileMenuTile(
            icon: Icons.phone_android_outlined,
            title: 'Device Details',
            showDivider: false,
            onTap: () => _comingSoon(context, 'Device Details'),
          ),
        ],
      ),
    );
  }
}
