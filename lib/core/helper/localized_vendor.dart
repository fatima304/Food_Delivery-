import 'package:flutter/widgets.dart';
import 'package:food_delivery/l10n/app_localizations.dart';
import 'package:food_delivery/domain/entities/vendor.dart';

/// Localized display labels for demo vendor data. Stable vendor IDs stay unchanged.
String localizedVendorCity(BuildContext context, Vendor vendor) {
  final l = AppLocalizations.of(context)!;
  switch (vendor.id) {
    case 'cairo':
      return l.vendorCityCairo;
    case 'giza':
      return l.vendorCityGiza;
    case 'alexandria':
      return l.vendorCityAlexandria;
    case 'mansoura':
      return l.vendorCityMansoura;
    case 'tanta':
      return l.vendorCityTanta;
    default:
      return vendor.city;
  }
}

String localizedVendorCuisine(BuildContext context, Vendor vendor) {
  final l = AppLocalizations.of(context)!;
  switch (vendor.id) {
    case 'cairo':
      return l.vendorCuisineEgyptian;
    case 'giza':
      return l.vendorCuisineGrills;
    case 'alexandria':
      return l.vendorCuisineSeafood;
    case 'mansoura':
      return l.vendorCuisineItalian;
    case 'tanta':
      return l.vendorCuisineFastFood;
    default:
      return vendor.cuisine;
  }
}

String localizedVendorName(BuildContext context, Vendor vendor) =>
    'StreetBite ${localizedVendorCity(context, vendor)}';
