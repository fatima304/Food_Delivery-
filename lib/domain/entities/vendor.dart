import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Demo vendor displayed on the Nearby Vendors map.
class Vendor {
  const Vendor({
    required this.id,
    required this.name,
    required this.city,
    required this.cuisine,
    required this.rating,
    required this.location,
  });

  final String id;
  final String name;
  final String city;
  final String cuisine;
  final double rating;
  final LatLng location;
}
