import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/core/routing/routes.dart';
import 'package:food_delivery/data/repositories/profile_repository.dart';
import 'package:food_delivery/l10n/app_localizations.dart';
import 'package:food_delivery/presentation/widgets/profile/profile_header.dart';
import 'package:food_delivery/presentation/widgets/profile/profile_menu_tile.dart';
import 'package:food_delivery/presentation/widgets/profile/edit_name_dialog.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({
    super.key,
    required this.repository,
    required this.localPhoto,
    required this.localPhotoUserId,
    required this.uploading,
    required this.onPhotoTap,
    required this.onSignOut,
    required this.signingOut,
  });

  final ProfileRepository repository;
  final File? localPhoto;
  final String? localPhotoUserId;
  final bool uploading;
  final VoidCallback onPhotoTap;
  final VoidCallback onSignOut;
  final bool signingOut;

  @override
  Widget build(BuildContext context) {
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
              onPhotoTap: onPhotoTap,
              onNameTap: () => _editName(context, name),
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
          onTap: signingOut ? null : onSignOut,
        ),
      ],
    );
  }

  Future<void> _editName(BuildContext context, String currentName) async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => EditNameDialog(initialName: currentName),
    );
    if (name == null || name.trim().isEmpty) return;
    try {
      await repository.updateName(name);
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.couldNotUpdateName),
          ),
        );
      }
    }
  }
}
