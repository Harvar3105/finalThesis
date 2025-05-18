import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressProvider extends StatefulWidget {
  final LatLng location;

  const AddressProvider({super.key, required this.location});

  @override
  _AddressProviderState createState() => _AddressProviderState();
}

class _AddressProviderState extends State<AddressProvider> {
  final Completer<GoogleMapController> _mapController = Completer();
  String? _mapStyle;

  Future<void> _loadMapStyle() async {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    rootBundle.loadString(
        isDarkMode ? 'assets/map_styles/dark_theme.json' : 'assets/map_styles/standard_theme.json'
    ).then((string) {
      setState(() {
        _mapStyle = string;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.location,
          zoom: 14.0,
        ),
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        rotateGesturesEnabled: true,
        tiltGesturesEnabled: true,
        markers: {
          Marker(
            markerId: const MarkerId('provided-location'),
            position: widget.location,
          ),
        },
        onMapCreated: (GoogleMapController controller) {
          _mapController.complete(controller);
          _loadMapStyle();
        },
        style: _mapStyle,
      ),
    );
  }
}
