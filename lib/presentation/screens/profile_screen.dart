import 'package:food_delivery/core/routing/routes.dart';
import 'package:food_delivery/core/helper/localized_state_error.dart';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:food_delivery/l10n/app_localizations.dart';

import '../../data/repositories/profile_repository.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../injection.dart';
import '../blocs/auth_cubit.dart';
import '../blocs/auth_state.dart';
import '../blocs/biometric_cubit.dart';
import '../blocs/biometric_state.dart';
import '../../core/widgets/app_nav.dart';
import '../widgets/profile/biometric_gate.dart';
import '../widgets/profile/profile_body.dart';

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
    return BiometricGate(
      state: state,
      onAuthenticate: () => context.read<BiometricCubit>().authenticate(),
      onLeave: () => _leaveProfile(context),
    );
  }

  Widget _buildProfile(BuildContext context) {
    return ProfileBody(
      repository: repository,
      localPhoto: localPhoto,
      localPhotoUserId: localPhotoUserId,
      uploading: uploading,
      onPhotoTap: _pickPhoto,
      onSignOut: _signOut,
      signingOut: signingOut,
    );
  }
}
