import 'package:food_delivery/l10n/app_localizations.dart';
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
            AppLocalizations.of(context)!.onboardingTitle,
            style: AppTextStyles.heading32BlackBold.copyWith(
              fontSize: isSmall ? 28 : 32,
            ),
          ),
          Text(
            AppLocalizations.of(context)!.onboardingAccent,
            style: AppTextStyles.onboardingGreenBold.copyWith(
              fontSize: isSmall ? 30 : 36,
            ),
          ),
          SizedBox(height: isSmall ? 8 : 12),
          Text(
            AppLocalizations.of(context)!.onboardingDescription,
            style: AppTextStyles.onboardingDescription,
          ),
          const Spacer(),
          SizedBox(height: isSmall ? 16 : 24),
          CustomButton(
            text: AppLocalizations.of(context)!.getStarted,
            onPressed: onStart,
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: onSignIn,
              child: Text(
                AppLocalizations.of(context)!.onboardingSignIn,
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
