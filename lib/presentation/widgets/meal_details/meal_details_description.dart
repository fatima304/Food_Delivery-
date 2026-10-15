import 'package:flutter/material.dart';
import 'package:food_delivery/core/style/app_text_styles.dart';
import 'package:food_delivery/l10n/app_localizations.dart';

class MealDetailsDescription extends StatefulWidget {
  const MealDetailsDescription({super.key, required this.description});

  final String description;

  @override
  State<MealDetailsDescription> createState() => _MealDetailsDescriptionState();
}

class _MealDetailsDescriptionState extends State<MealDetailsDescription> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final green = colors.primary;
    final muted = colors.onSurfaceVariant;
    final l10n = AppLocalizations.of(context)!;

    final descriptionStyle = AppTextStyles.body14GreyRegular.copyWith(
      color: muted,
      height: 1.6,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final textPainter = TextPainter(
          text: TextSpan(text: widget.description, style: descriptionStyle),
          maxLines: 4,
          textDirection: Directionality.of(context),
        )..layout(maxWidth: constraints.maxWidth);

        final hasMoreText = textPainter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.description,
              maxLines: isExpanded ? null : 4,
              overflow: isExpanded
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,
              style: descriptionStyle,
            ),
            if (hasMoreText) ...[
              const SizedBox(height: 6),
              InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isExpanded ? l10n.seeLess : l10n.seeMore,
                        style: AppTextStyles.body14GreyRegular.copyWith(
                          color: green,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        size: 20,
                        color: green,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
