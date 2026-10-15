import 'package:flutter/material.dart';

/// Displays a meal image with a simple fallback if the URL cannot load.
class MealImage extends StatelessWidget {
  const MealImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 0,
    this.placeholderIcon = Icons.restaurant_menu_rounded,
    this.placeholderSize = 36,
    this.fallback,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final IconData placeholderIcon;
  final double placeholderSize;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final placeholder =
        fallback ??
        ColoredBox(
          color: colors.surfaceContainerLow,
          child: Center(
            child: Icon(
              placeholderIcon,
              color: colors.primary,
              size: placeholderSize,
            ),
          ),
        );

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        width: width,
        height: height,
        child: imageUrl.isEmpty
            ? placeholder
            : Image.network(
                imageUrl,
                width: width,
                height: height,
                fit: fit,
                errorBuilder: (_, _, _) => placeholder,
              ),
      ),
    );
  }
}
