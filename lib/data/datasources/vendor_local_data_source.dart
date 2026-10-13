import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/vendor.dart';

/// Demonstration locations, not verified restaurant branches.
class VendorLocalDataSource {
  const VendorLocalDataSource();

  List<Vendor> getVendors() => const [
    Vendor(
      id: 'cairo',
      name: 'StreetBite Cairo',
      city: 'Cairo',
      cuisine: 'Egyptian',
      rating: 4.8,
      location: LatLng(30.0444, 31.2357),
    ),
    Vendor(
      id: 'giza',
      name: 'StreetBite Giza',
      city: 'Giza',
      cuisine: 'Grills',
      rating: 4.6,
      location: LatLng(30.0131, 31.2089),
    ),
    Vendor(
      id: 'alexandria',
      name: 'StreetBite Alexandria',
      city: 'Alexandria',
      cuisine: 'Seafood',
      rating: 4.7,
      location: LatLng(31.2001, 29.9187),
    ),
    Vendor(
      id: 'mansoura',
      name: 'StreetBite Mansoura',
      city: 'Mansoura',
      cuisine: 'Italian',
      rating: 4.5,
      location: LatLng(31.0409, 31.3785),
    ),
    Vendor(
      id: 'tanta',
      name: 'StreetBite Tanta',
      city: 'Tanta',
      cuisine: 'Fast Food',
      rating: 4.4,
      location: LatLng(30.7865, 31.0004),
    ),
  ];
}
