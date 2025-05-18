import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../configurations/app_colours.dart';
import '../../../../configurations/strings.dart';


class AddressPickerWithConfirmation extends StatefulWidget {
  final Function(LatLng address) onAddressSelected;
  final LatLng? givenLocation;

  const AddressPickerWithConfirmation({
    super.key,
    required this.onAddressSelected,
    this.givenLocation,
  });

  @override
  _AddressPickerState createState() => _AddressPickerState();
}

class _AddressPickerState extends State<AddressPickerWithConfirmation> {
  final Completer<GoogleMapController> _mapController = Completer();
  LatLng? _currentPosition;
  String? _selectedAddress;
  String? _mapStyle;

  @override
  void initState() {
    super.initState();
    if (widget.givenLocation != null) {
      _currentPosition = widget.givenLocation!;
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

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });

    if (_currentPosition != null) {
      _getAddressFromLatLng(_currentPosition!);
    }
  }

  Future<void> _getAddressFromLatLng(LatLng latLng) async {
    List<Placemark> placemarks =
    await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      setState(() {
        _selectedAddress =
        '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
      });
    }
  }

  Future<void> _loadMapStyle() async {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    rootBundle
        .loadString(isDarkMode
        ? 'assets/map_styles/dark_theme.json'
        : 'assets/map_styles/standard_theme.json')
        .then((string) {
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
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                      () => EagerGestureRecognizer()),
            },
            onMapCreated: (GoogleMapController controller) {
              _mapController.complete(controller);
              _loadMapStyle();
            },
            onTap: (LatLng position) async {
              setState(() {
                _currentPosition = position;
              });
              final GoogleMapController mapController =
              await _mapController.future;
              mapController.animateCamera(
                  CameraUpdate.newLatLng(position));
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
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            if (_currentPosition == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(Strings.selectLocation),
                ),
              );
            } else {
              widget.onAddressSelected(_currentPosition!);
            }
          },
          child: const Text(Strings.confirmLocation),
        ),
      ],
    );
  }
}
