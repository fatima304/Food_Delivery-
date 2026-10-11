import 'package:flutter/material.dart';

class ResponsiveHelper {
  static double width(BuildContext context) => MediaQuery.sizeOf(context).width;

  static double height(BuildContext context) =>
      MediaQuery.sizeOf(context).height;

  static bool isSmallMobile(BuildContext context) => width(context) < 360;

  static double horizontalPadding(BuildContext context) =>
      isSmallMobile(context) ? 16 : 24;

  static double responsiveValue(
    BuildContext context, {
    required double small,
    required double normal,
  }) => isSmallMobile(context) ? small : normal;
}
