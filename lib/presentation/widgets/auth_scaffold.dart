import 'package:flutter/material.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({super.key, required this.child, this.showBack = true});
  final Widget child;
  final bool showBack;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showBack)
                  IconButton(
                    onPressed: () => Navigator.maybePop(context),
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                  ),
                if (showBack) const SizedBox(height: 48),
                child,
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
