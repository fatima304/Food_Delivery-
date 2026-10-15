import 'package:flutter/material.dart';
import 'package:food_delivery/core/style/app_text_styles.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title, required this.color});

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.body16DarkRegular.copyWith(
        color: color,
        fontWeight: FontWeight.w700,
        fontSize: 15,
      ),
    );
  }
}
