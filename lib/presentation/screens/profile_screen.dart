import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/repositories/profile_repository.dart';

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

class _ProfileContent extends StatefulWidget {
  const _ProfileContent();
  @override
  State<_ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<_ProfileContent> {
  bool uploading = false;
  File? localPhoto;
  String? localPhotoUserId;
  final repository = getIt<ProfileRepository>();

  @override
  void initState() {
    super.initState();
    _loadLocalPhoto();
  }

  Future<void> _loadLocalPhoto() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    try {
      final file = await repository.localPhoto();
      if (mounted && FirebaseAuth.instance.currentUser?.uid == uid) {
        setState(() {
          localPhoto = file;
          localPhotoUserId = uid;
        });
      }
    } catch (_) {
      // A missing local image should not prevent opening the profile.
    }
  }

  Future<void> _pickPhoto() async {
    if (uploading) return;
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 75,
        maxWidth: 1024,
      );
      if (image == null || !mounted) return;
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw StateError('Please sign in first.');
      setState(() => uploading = true);
      final saved = await repository.saveLocalPhoto(File(image.path));
      await FileImage(saved).evict();
      if (!mounted || FirebaseAuth.instance.currentUser?.uid != uid) return;
      setState(() {
        localPhoto = saved;
        localPhotoUserId = uid;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Photo saved on this device.')),
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not save photo: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => uploading = false);
    }
  }

  Future<void> _editName(String current) async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => _EditNameDialog(initialName: current),
    );
    if (!mounted) return;
    if (name == null || name.trim().isEmpty) return;
    try {
      await repository.updateName(name);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not update name: $error')),
        );
      }
    }
  }

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
      StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: repository.watchProfile(),
        builder: (context, snapshot) {
          final data = snapshot.data?.data() ?? {};
          final user = FirebaseAuth.instance.currentUser;
          final storedName = data['name'] as String?;
          final name = storedName?.trim().isNotEmpty == true
              ? storedName!
              : (user?.displayName?.trim().isNotEmpty == true
                    ? user!.displayName!
                    : 'StreetBite User');
          final uid = user?.uid;
          final photo = localPhotoUserId == uid ? localPhoto : null;
          return ProfileHeader(
            name: name,
            email: user?.email ?? '',
            localPhoto: photo,
            uploading: uploading,
            onPhotoTap: _pickPhoto,
            onNameTap: () => _editName(name),
          );
        },
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

class _EditNameDialog extends StatefulWidget {
  const _EditNameDialog({required this.initialName});
  final String initialName;

  @override
  State<_EditNameDialog> createState() => _EditNameDialogState();
}

class _EditNameDialogState extends State<_EditNameDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Edit name'),
    content: TextField(
      controller: _controller,
      autofocus: true,
      textCapitalization: TextCapitalization.words,
      decoration: const InputDecoration(labelText: 'Full name'),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(context, _controller.text.trim()),
        child: const Text('Save'),
      ),
    ],
  );
}
