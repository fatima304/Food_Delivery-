import 'package:flutter/material.dart';

/// Matches the chevron used on the meal details screen.
class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
      onPressed: onPressed ?? () => Navigator.of(context).maybePop(),
    );
  }
}
