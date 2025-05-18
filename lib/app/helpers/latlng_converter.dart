import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LatLngConverter implements JsonConverter<LatLng?, Map<String, dynamic>?> {
  const LatLngConverter();

  @override
  LatLng? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return LatLng(json['latitude'] as double, json['longitude'] as double);
  }

  @override
  Map<String, dynamic>? toJson(LatLng? latLng){
    if (latLng == null) {
      return null;
    }
    return {
      'latitude': latLng.latitude,
      'longitude': latLng.longitude,
    };
  }
}