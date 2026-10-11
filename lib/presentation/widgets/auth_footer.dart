import 'package:flutter/material.dart';
import 'package:food_delivery/core/style/app_text_styles.dart';

class AuthFooter extends StatelessWidget {
  const AuthFooter({
    super.key,
    required this.message,
    required this.action,
    required this.onTap,
  });
  final String message, action;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Flexible(child: Text(message, style: AppTextStyles.body14DarkRegular)),
      TextButton(
        onPressed: onTap,
        child: Text(action, style: AppTextStyles.link16GreenSemiBold),
      ),
    ],
  );
}
