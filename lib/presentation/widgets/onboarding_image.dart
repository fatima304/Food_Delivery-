import 'package:flutter/material.dart';
import 'package:food_delivery/core/constants/app_images.dart';
import 'package:food_delivery/core/helper/responsive_helper.dart';

class OnboardingImage extends StatelessWidget {
  const OnboardingImage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = ResponsiveHelper.height(context);

    final imageHeight = (screenHeight * 0.40).clamp(190.0, 360.0).toDouble();

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
