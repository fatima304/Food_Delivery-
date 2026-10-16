import 'package:flutter/material.dart';
import 'package:food_delivery/core/helper/responsive_helper.dart';

class ResponsiveContent extends StatelessWidget {
  const ResponsiveContent({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.horizontalPadding(context),
      ),
      child: child,
    );
  }
}
