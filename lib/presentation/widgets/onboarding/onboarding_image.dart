import 'package:flutter/material.dart';
import 'package:food_delivery/core/constants/app_images.dart';

class OnboardingImage extends StatelessWidget {
  const OnboardingImage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight =
        MediaQuery.sizeOf(context).height -
        MediaQuery.paddingOf(context).vertical;

    final imageHeight = (screenHeight * 0.36).clamp(160.0, 340.0).toDouble();

    return SizedBox(
      width: double.infinity,
      height: imageHeight,
      child: Image.asset(
        AppImages.onboardingFood,
        fit: BoxFit.cover,
        alignment: Alignment.centerRight,
      ),
    );
  }
}
