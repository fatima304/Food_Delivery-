import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/style/app_text_styles.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController animation;
  @override
  void initState() {
    super.initState();
    animation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..forward();
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: FadeTransition(
        opacity: animation,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 44,
              backgroundColor: AppColors.primaryGreen,
              child: Icon(Icons.restaurant, size: 45, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              'StreetBite',
              style: AppTextStyles.heading36BlackBold.copyWith(
                color: AppColors.darkGreen,
              ),
            ),
            const Text('Good Food. Brighter Mood.'),
          ],
        ),
      ),
    ),
  );
}
