import 'package:flutter/material.dart';
import 'package:food_delivery/core/helper/localized_vendor.dart';
import 'package:food_delivery/domain/entities/vendor.dart';

class VendorChipList extends StatelessWidget {
  const VendorChipList({
    super.key,
    required this.vendors,
    required this.onVendorSelected,
  });

  final List<Vendor> vendors;
  final Function(Vendor) onVendorSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 94,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: vendors.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final vendor = vendors[index];
          return ActionChip(
            avatar: Icon(Icons.location_on, size: 17, color: scheme.primary),
            label: Text(localizedVendorCity(context, vendor)),
            backgroundColor: scheme.surface,
            onPressed: () => onVendorSelected(vendor),
          );
        },
      ),
    );
  }
}
