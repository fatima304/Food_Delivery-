import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../data/datasources/vendor_local_data_source.dart';
import '../../domain/entities/vendor.dart';
import '../widgets/vendor_details_card.dart';

class NearbyVendorsScreen extends StatefulWidget {
  const NearbyVendorsScreen({super.key});

  @override
  State<NearbyVendorsScreen> createState() => _NearbyVendorsScreenState();
}

class _NearbyVendorsScreenState extends State<NearbyVendorsScreen> {
  static const _initialCamera = CameraPosition(
    target: LatLng(30.55, 30.75),
    zoom: 7.1,
  );

  final List<Vendor> _vendors = const VendorLocalDataSource().getVendors();
  GoogleMapController? _mapController;
  Vendor? _selectedVendor;

  Set<Marker> get _markers => _vendors.map((vendor) {
        return Marker(
          markerId: MarkerId(vendor.id),
          position: vendor.location,
          infoWindow: InfoWindow(title: vendor.name, snippet: vendor.cuisine),
          onTap: () => _selectVendor(vendor),
        );
      }).toSet();

  Future<void> _selectVendor(Vendor vendor) async {
    if (!mounted) return;
    setState(() => _selectedVendor = vendor);
    await _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: vendor.location, zoom: 12.5)),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Vendors'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() => _selectedVendor = null);
              _mapController?.animateCamera(CameraUpdate.newCameraPosition(_initialCamera));
            },
            tooltip: 'Show all vendors',
            icon: const Icon(Icons.zoom_out_map_rounded),
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialCamera,
            markers: _markers,
            mapType: MapType.normal,
            compassEnabled: true,
            zoomControlsEnabled: false,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            onMapCreated: (controller) => _mapController = controller,
            onTap: (_) => setState(() => _selectedVendor = null),
          ),
          Positioned(
            left: 16,
            right: 16,
            top: 16,
            child: Material(
              color: scheme.surface,
              elevation: 2,
              borderRadius: BorderRadius.circular(18),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(children: [
                  Icon(Icons.storefront_rounded, color: scheme.primary),
                  const SizedBox(width: 10),
                  const Expanded(child: Text('Explore 5 demo vendors across Egypt',
                      style: TextStyle(fontWeight: FontWeight.w600))),
                ]),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: SafeArea(
              top: false,
              child: _selectedVendor != null
                  ? VendorDetailsCard(
                      vendor: _selectedVendor!,
                      onClose: () => setState(() => _selectedVendor = null),
                      onLocate: () => _selectVendor(_selectedVendor!),
                    )
                  : SizedBox(
                      height: 94,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _vendors.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final vendor = _vendors[index];
                          return ActionChip(
                            avatar: Icon(Icons.location_on, size: 17, color: scheme.primary),
                            label: Text(vendor.city),
                            backgroundColor: scheme.surface,
                            onPressed: () => _selectVendor(vendor),
                          );
                        },
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
