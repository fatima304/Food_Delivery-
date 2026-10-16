import 'package:food_delivery/core/helper/localized_vendor.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/l10n/app_localizations.dart';

import '../../../domain/entities/vendor.dart';

class VendorDetailsCard extends StatelessWidget {
  const VendorDetailsCard({
    super.key,
    required this.vendor,
    required this.onClose,
    required this.onLocate,
  });

  final Vendor vendor;
  final VoidCallback onClose;
  final VoidCallback onLocate;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Material(
      color: scheme.surface,
      elevation: 5,
      borderRadius: BorderRadius.circular(22),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.restaurant_rounded,
                color: scheme.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    localizedVendorName(context, vendor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${localizedVendorCity(context, vendor)} • ${localizedVendorCuisine(context, vendor)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: scheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFFFB020),
                        size: 18,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        vendor.rating.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close),
                  tooltip: l10n.closeDetails,
                ),
                IconButton.filledTonal(
                  onPressed: onLocate,
                  icon: const Icon(Icons.my_location),
                  tooltip: l10n.showOnMap,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
