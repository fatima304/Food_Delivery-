import 'package:flutter/material.dart';
import 'package:food_delivery/l10n/app_localizations.dart';

class MapInfoBanner extends StatelessWidget {
  const MapInfoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Material(
      color: scheme.surface,
      elevation: 2,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Icon(Icons.storefront_rounded, color: scheme.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                l10n.exploreDemoVendors,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
