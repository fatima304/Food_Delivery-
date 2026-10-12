import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_images.dart';
import '../../core/style/app_text_styles.dart';

class SectionHeading extends StatelessWidget {
  const SectionHeading(this.title, {super.key, this.action});
  final String title;
  final VoidCallback? action;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(
      children: [
        Expanded(child: Text(title)),
        if (action != null)
          TextButton(onPressed: action, child: const Text('See all')),
      ],
    ),
  );
}

class FoodPhoto extends StatelessWidget {
  const FoodPhoto({super.key, this.height = 115, this.width = double.infinity});
  final double height, width;
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: Image.asset(
      AppImages.onboardingFood,
      width: width,
      height: height,
      fit: BoxFit.cover,
      alignment: Alignment.centerRight,
    ),
  );
}

class GreenTag extends StatelessWidget {
  const GreenTag(this.label, {super.key});
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: AppColors.lightGreen,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Text(label, style: AppTextStyles.link14GreenMedium),
  );
}

class UiCard extends StatelessWidget {
  const UiCard({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Card(
    elevation: 0,
    color: Theme.of(context).colorScheme.surfaceContainerLow,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(padding: const EdgeInsets.all(12), child: child),
  );
}

void showDemo(
  BuildContext context, [
  String message = 'UI preview only — connect your Bloc / Firebase',
]) =>
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
