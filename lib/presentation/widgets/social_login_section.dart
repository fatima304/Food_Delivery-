import 'package:food_delivery/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/core/constants/app_images.dart';
import 'package:food_delivery/core/style/app_text_styles.dart';

class SocialLoginSection extends StatelessWidget {
  const SocialLoginSection({super.key});
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              AppLocalizations.of(context)!.orContinueWith,
              style: AppTextStyles.body14GreyRegular.copyWith(
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
          const Expanded(child: Divider()),
        ],
      ),
      const SizedBox(height: 24),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _SocialTile(img: AppImages.google),
          const SizedBox(width: 12),
          _SocialTile(img: AppImages.apple),
          const SizedBox(width: 12),
          _SocialTile(img: AppImages.facebook),
        ],
      ),
    ],
  );
}

class _SocialTile extends StatelessWidget {
  const _SocialTile({required this.img});
  final String img;
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Image.asset(img, width: 24, height: 24),
    ),
  );
}
