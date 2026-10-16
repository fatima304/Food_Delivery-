import 'package:flutter/material.dart';
import 'package:food_delivery/core/routing/routes.dart';
import 'package:food_delivery/l10n/app_localizations.dart';

class NearbyVendorsCard extends StatelessWidget {
  const NearbyVendorsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Material(
      color: colors.primaryContainer,
      borderRadius: BorderRadius.circular(18),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        leading: Icon(Icons.map_outlined, color: colors.primary, size: 30),
        title: Text(
          l10n.nearbyVendors,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(l10n.nearbyVendorsSubtitle),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          color: colors.primary,
          size: 18,
        ),
        onTap: () => Navigator.pushNamed(context, Routes.nearbyVendors),
      ),
    );
  }
}
