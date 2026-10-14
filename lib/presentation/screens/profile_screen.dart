import 'package:food_delivery/core/routing/routes.dart';
import 'package:food_delivery/core/helper/localized_state_error.dart';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:food_delivery/l10n/app_localizations.dart';

import '../../data/repositories/profile_repository.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../injection.dart';
import '../blocs/auth_cubit.dart';
import '../blocs/auth_state.dart';
import '../blocs/biometric_cubit.dart';
import '../blocs/biometric_state.dart';
import '../widgets/app_nav.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => const _ProfileContent();
}

class _ProfileContent extends StatefulWidget {
  const _ProfileContent();
  @override
  State<_ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<_ProfileContent> {
  bool uploading = false;
  bool signingOut = false;
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
        SnackBar(content: Text(AppLocalizations.of(context)!.photoSaved)),
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.couldNotSavePhoto),
          ),
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
          SnackBar(
            content: Text(AppLocalizations.of(context)!.couldNotUpdateName),
          ),
        );
      }
    }
  }

  Future<void> _signOut() async {
    if (signingOut) return;
    setState(() => signingOut = true);
    final authCubit = context.read<AuthCubit>();
    await authCubit.logout();
    if (!mounted) return;
    if (FirebaseAuth.instance.currentUser == null) {
      // Return to the first route (AuthGate), which reacts to Firebase sign-out.
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      setState(() => signingOut = false);
      final error = authCubit.state;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error is AuthError
                ? localizedStateError(context, error.message)
                : AppLocalizations.of(context)!.errorSomethingWrong,
          ),
        ),
      );
    }
  }

  void _leaveProfile(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, Routes.home, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<BiometricCubit, BiometricState>(
      builder: (context, auth) {
        final unlocked = auth.status == BiometricStatus.success;
        return Scaffold(
          backgroundColor: scheme.surface,
          appBar: AppBar(
            title: Text(l10n.profile),
            centerTitle: true,
            backgroundColor: scheme.surface,
            automaticallyImplyLeading: false,
          ),
          bottomNavigationBar: unlocked ? const AppNav(index: 4) : null,
          body: unlocked
              ? _buildProfile(context)
              : _buildBiometricGate(context, auth, l10n),
        );
      },
    );
  }

  Widget _buildBiometricGate(
    BuildContext context,
    BiometricState state,
    AppLocalizations l10n,
  ) {
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
              busy ? l10n.verifyingIdentity : l10n.unlockProfile,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (!busy) ...[
              const SizedBox(height: 10),
              Text(
                state.errorMessage == null
                    ? l10n.biometricRequired
                    : localizedStateError(context, state.errorMessage),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () => context.read<BiometricCubit>().authenticate(),
                icon: const Icon(Icons.fingerprint),
                label: Text(l10n.tryAgain),
              ),
              TextButton(
                onPressed: () => _leaveProfile(context),
                child: Text(l10n.backToHome),
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

  Widget _buildProfile(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      children: [
        const SizedBox(height: 10),

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
                      : l10n.streetBiteUser);
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
        const SizedBox(height: 10),
        ProfileMenuTile(
          icon: Icons.favorite_border,
          title: l10n.favourites,
          onTap: () => Navigator.pushNamed(context, Routes.favourites),
        ),
        const SizedBox(height: 10),
        ProfileMenuTile(
          icon: Icons.receipt_long_outlined,
          title: l10n.orderHistory,
          onTap: () => Navigator.pushNamed(context, Routes.orders),
        ),
        const SizedBox(height: 10),
        ProfileMenuTile(
          icon: Icons.settings_outlined,
          title: l10n.settings,
          onTap: () => Navigator.pushNamed(context, Routes.settings),
        ),
        const SizedBox(height: 10),
        ProfileMenuTile(
          icon: Icons.logout_rounded,
          title: l10n.signOut,
          onTap: signingOut ? null : _signOut,
        ),
      ],
    );
  }
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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.editName),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(labelText: l10n.fullName),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _controller.text.trim()),
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
