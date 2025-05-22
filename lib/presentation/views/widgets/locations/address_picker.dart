import 'dart:async';
import 'dart:convert';
import 'package:final_thesis_app/configurations/firebase_api_keys.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

import '../../../../configurations/app_colours.dart';
import '../../../../configurations/strings.dart';

class AddressPicker extends StatefulWidget {
  final Function(LatLng address) onAddressSelected;
  final LatLng? givenLocation;

  const AddressPicker({super.key, required this.onAddressSelected, this.givenLocation});

  @override
  _AddressPickerState createState() => _AddressPickerState();
}

class _AddressPickerState extends State<AddressPicker> {
  final Completer<GoogleMapController> _mapController = Completer();
  LatLng? _currentPosition;
  String? _selectedAddress;
  String? _mapStyle;

  @override
  void initState() {
    super.initState();
    if (widget.givenLocation != null) {
      _currentPosition = widget.givenLocation!;
      widget.onAddressSelected(_currentPosition!);
      _getAddressFromLatLng(_currentPosition!);
    } else {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });

    if (_currentPosition != null) {
      widget.onAddressSelected(_currentPosition!);
      _getAddressFromLatLng(_currentPosition!);
    }
  }

  Future<void> _getAddressFromLatLng(LatLng latLng) async {
    try {
      // For physical devices
      List<Placemark> placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          _selectedAddress = '${place.street}, ${place.locality}, ${place.administrativeArea}';
        });
        widget.onAddressSelected(latLng);
      }
    } catch (e) {
      // For web
      try {
        final url =
            'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=${ApiKeys.googleApiKey}&language=en';

        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final results = data['results'] as List<dynamic>;

          if (results.isNotEmpty) {
            var parts = (results.first['formatted_address'] as String).split(',');
            var address = parts.sublist(0, parts.length - 1).join(',').trim();
            setState(() {
              _selectedAddress = address;
            });
          }
        }
      } catch (e) {
        setState(() {
          _selectedAddress = 'Error getting address!\nCoordinates are: ${latLng.latitude}, ${latLng.longitude}';
        });
      }
    }
  }

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
    return _currentPosition == null
        ? const Center(child: CircularProgressIndicator())
        : Column(
      children: [
        SizedBox(
          height: 300,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentPosition!,
              zoom: 16.0,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            rotateGesturesEnabled: true,
            tiltGesturesEnabled: true,
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
            },
            onMapCreated: (GoogleMapController controller) {
              _mapController.complete(controller);
              _loadMapStyle();
            },
            onTap: (LatLng position) async {
              setState(() {
                _currentPosition = position;
              });
              final GoogleMapController mapController = await _mapController.future;
              mapController.animateCamera(CameraUpdate.newLatLng(position));
              _getAddressFromLatLng(position);
            },
            style: _mapStyle,
            markers: {
              Marker(
                markerId: const MarkerId('selected-location'),
                position: _currentPosition!,
              ),
            },
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
              color: AppColors.profileButtons,
              borderRadius: BorderRadius.circular(5)
            // borderRadius: BorderRadius.circular(60),
            // color: Theme.of(context).colorScheme.surface
          ),
          child: Text(
            _selectedAddress ?? Strings.selectLocation,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
            ),
          ),
        ),
      ],
    );
  }
}
