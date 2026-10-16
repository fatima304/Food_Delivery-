import '../../core/widgets/app_back_button.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:food_delivery/l10n/app_localizations.dart';

import '../../data/datasources/vendor_local_data_source.dart';
import '../../domain/entities/vendor.dart';
import '../widgets/nearby_vendors/vendor_details_card.dart';
import '../widgets/nearby_vendors/vendor_map.dart';
import '../widgets/nearby_vendors/vendor_chip_list.dart';
import '../widgets/nearby_vendors/map_info_banner.dart';

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

  Future<void> _selectVendor(Vendor vendor) async {
    if (!mounted) return;
    setState(() => _selectedVendor = vendor);
    await _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: vendor.location, zoom: 12.5),
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: Text(l10n.nearbyVendors),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() => _selectedVendor = null);
              _mapController?.animateCamera(
                CameraUpdate.newCameraPosition(_initialCamera),
              );
            },
            tooltip: l10n.showAllVendors,
            icon: const Icon(Icons.zoom_out_map_rounded),
          ),
        ],
      ),
      body: Stack(
        children: [
          VendorMap(
            vendors: _vendors,
            initialCamera: _initialCamera,
            onMapCreated: (controller) => _mapController = controller,
            onMarkerTap: _selectVendor,
            onMapTap: () => setState(() => _selectedVendor = null),
          ),
          const Positioned(
            left: 16,
            right: 16,
            top: 16,
            child: MapInfoBanner(),
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
                  : VendorChipList(
                      vendors: _vendors,
                      onVendorSelected: _selectVendor,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
