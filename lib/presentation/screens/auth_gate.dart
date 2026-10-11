import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/presentation/screens/onboarding_screen.dart';
import 'package:food_delivery/presentation/screens/auth_home_screen.dart';

/// Firebase's auth stream is the source of truth, including after app restart.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  @override
  Widget build(BuildContext context) => StreamBuilder<User?>(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      if (snapshot.hasError) {
        return const Scaffold(
          body: Center(
            child: Text(
              'Unable to check your session. Please restart the app.',
            ),
          ),
        );
      }
      return snapshot.data == null
          ? const OnboardingScreen()
          : const AuthHomeScreen();
    },
  );
}
