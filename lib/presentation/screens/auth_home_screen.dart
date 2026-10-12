import 'package:food_delivery/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_delivery/presentation/blocs/auth_cubit.dart';
import 'package:food_delivery/presentation/blocs/auth_state.dart';
import 'package:food_delivery/presentation/widgets/auth_feedback.dart';

/// Temporary authenticated landing page. Replace with your real Home screen.
class AuthHomeScreen extends StatelessWidget {
  const AuthHomeScreen({super.key});
  @override
  Widget build(BuildContext context) => BlocListener<AuthCubit, AuthState>(
    listener: (context, state) {
      if (state is AuthError) showAuthFeedback(context, state.message);
    },
    child: Scaffold(
      appBar: AppBar(title: const Text('StreetBite')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 56),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.signedIn),
            const SizedBox(height: 8),
            Text(FirebaseAuth.instance.currentUser?.email ?? ''),
            const SizedBox(height: 24),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) => ElevatedButton(
                onPressed: state is AuthLoading
                    ? null
                    : () => context.read<AuthCubit>().logout(),
                child: state is AuthLoading
                    ? const CircularProgressIndicator()
                    : Text(AppLocalizations.of(context)!.signOut),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
