import 'package:flutter/material.dart';
import 'package:food_delivery/core/style/app_text_styles.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.title, required this.subtitle});
  final String title, subtitle;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: AppTextStyles.heading32BlackBold),
      const SizedBox(height: 8),
      Text(subtitle, style: AppTextStyles.body18GreyRegular),
      const SizedBox(height: 40),
    ],
  );
}
