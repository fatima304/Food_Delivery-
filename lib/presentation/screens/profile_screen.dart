import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../injection.dart';
import '../blocs/biometric_cubit.dart';
import '../blocs/biometric_state.dart';
import '../widgets/app_nav.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_tile.dart';
import 'favourites_screen.dart';
import 'home_screen.dart';
import 'orders_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => getIt<BiometricCubit>()..authenticate()),
    ],
    child: const _ProfileContent(),
  );
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent();

  void _comingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$feature is coming soon')));
  }

  void _leaveProfile(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return BlocBuilder<BiometricCubit, BiometricState>(
      builder: (context, auth) {
        final unlocked = auth.status == BiometricStatus.success;
        return Scaffold(
          backgroundColor: scheme.surface,
          appBar: AppBar(
            title: const Text('Profile'),
            centerTitle: true,
            backgroundColor: scheme.surface,
            automaticallyImplyLeading: false,
            leading: unlocked
                ? null
                : IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => _leaveProfile(context),
                  ),
          ),
          bottomNavigationBar: unlocked ? const AppNav(index: 4) : null,
          body: unlocked
              ? _buildProfile(context)
              : _buildBiometricGate(context, auth),
        );
      },
    );
  }

  Widget _buildBiometricGate(BuildContext context, BiometricState state) {
    final busy =
        state.status == BiometricStatus.loading ||
        state.status == BiometricStatus.initial;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.fingerprint, size: 64),
            const SizedBox(height: 16),
            Text(
              busy ? 'Verifying your identity...' : 'Unlock your profile',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (!busy) ...[
              const SizedBox(height: 10),
              Text(
                state.errorMessage ?? 'Biometric authentication is required.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () => context.read<BiometricCubit>().authenticate(),
                icon: const Icon(Icons.fingerprint),
                label: const Text('Try again'),
              ),
              TextButton(
                onPressed: () => _leaveProfile(context),
                child: const Text('Back to Home'),
              ),
            ] else ...[
              const SizedBox(height: 20),
              const CircularProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProfile(BuildContext context) => ListView(
    children: [
      ProfileHeader(
        onPhotoTap: () => _comingSoon(context, 'Gallery photo upload'),
      ),
      const SizedBox(height: 8),
      ProfileMenuTile(
        icon: Icons.favorite_border,
        title: 'Favourites',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FavouritesScreen()),
        ),
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

    ],
  );
}
