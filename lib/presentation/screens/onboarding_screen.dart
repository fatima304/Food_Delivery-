import 'package:food_delivery/core/routing/routes.dart';
import 'package:flutter/material.dart';

import '../widgets/onboarding_image.dart';
import '../widgets/onboarding_content.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const OnboardingImage(),
                      Expanded(
                        child: OnboardingContent(
                          onStart: () =>
                              Navigator.pushNamed(context, Routes.signup),
                          onSignIn: () =>
                              Navigator.pushNamed(context, Routes.login),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
