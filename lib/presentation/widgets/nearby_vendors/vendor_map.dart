import 'package:flutter/material.dart';
import 'package:food_delivery/core/helper/localized_vendor.dart';
import 'package:food_delivery/domain/entities/vendor.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class VendorMap extends StatelessWidget {
  const VendorMap({
    super.key,
    required this.vendors,
    required this.initialCamera,
    required this.onMapCreated,
    required this.onMarkerTap,
    required this.onMapTap,
  });

  final List<Vendor> vendors;
  final CameraPosition initialCamera;
  final Function(GoogleMapController) onMapCreated;
  final Function(Vendor) onMarkerTap;
  final VoidCallback onMapTap;

  @override
  Widget build(BuildContext context) {
    final markers = vendors.map((vendor) {
      return Marker(
        markerId: MarkerId(vendor.id),
        position: vendor.location,
        infoWindow: InfoWindow(
          title: localizedVendorName(context, vendor),
          snippet:
              "${localizedVendorCuisine(context, vendor)} • ${vendor.rating.toStringAsFixed(1)} ★",
        ),
        onTap: () => onMarkerTap(vendor),
      );
    }).toSet();

    return GoogleMap(
      initialCameraPosition: initialCamera,
      markers: markers,
      mapType: MapType.normal,
      compassEnabled: true,
      zoomControlsEnabled: false,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      onMapCreated: onMapCreated,
      onTap: (_) => onMapTap(),
    );
  }
}
