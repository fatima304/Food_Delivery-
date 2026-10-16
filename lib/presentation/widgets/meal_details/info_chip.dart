import 'package:flutter/material.dart';
import 'package:food_delivery/core/style/app_text_styles.dart';

class InfoChip extends StatelessWidget {
  const InfoChip({
    super.key,
    required this.icon,
    required this.text,
    required this.green,
    required this.muted,
  });

  final IconData icon;
  final String text;
  final Color green;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: green),
        const SizedBox(width: 5),
        Text(
          text,
          style: AppTextStyles.body14GreyRegular.copyWith(
            color: muted,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
