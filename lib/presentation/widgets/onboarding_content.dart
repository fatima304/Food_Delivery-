import 'package:flutter/material.dart';
import 'package:food_delivery/core/helper/responsive_helper.dart';
import 'package:food_delivery/core/style/app_text_styles.dart';
import 'package:food_delivery/presentation/widgets/custom_button.dart';

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({
    super.key,
    required this.onStart,
    required this.onSignIn,
  });

  final VoidCallback onStart;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    final isSmall = ResponsiveHelper.isSmallMobile(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.horizontalPadding(context),
        vertical: isSmall ? 8 : 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delicious food\ndelivered to',
            style: AppTextStyles.heading32BlackBold.copyWith(
              fontSize: isSmall ? 28 : 32,
            ),
          ),
          Text(
            'your doorstep',
            style: AppTextStyles.onboardingGreenBold.copyWith(
              fontSize: isSmall ? 30 : 36,
            ),
          ),
          SizedBox(height: isSmall ? 8 : 12),
          const Text(
            'Discover the best restaurants near you '
            'and enjoy your favorite meals at home.',
            style: AppTextStyles.onboardingDescription,
          ),
          const Spacer(),
          SizedBox(height: isSmall ? 16 : 24),
          CustomButton(text: 'Get Started  →', onPressed: onStart),
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: onSignIn,
              child: const Text(
                'Already have an account?  Sign In',
                style: AppTextStyles.link14GreenMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
