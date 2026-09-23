import 'package:google_maps_flutter/google_maps_flutter.dart';

enum MapPickerMode { add, edit, select, onboarding }

class MapPickerArgs {
  const MapPickerArgs({
    this.initialLatitude,
    this.initialLongitude,
    this.initialAddress,
    this.mode = MapPickerMode.select,
  });

  final double? initialLatitude;
  final double? initialLongitude;
  final String? initialAddress;
  final MapPickerMode mode;

  LatLng? get initialLatLng {
    final latitude = initialLatitude;
    final longitude = initialLongitude;
    if (latitude == null || longitude == null) return null;
    return LatLng(latitude, longitude);
  }
}

class MapPickerResult {
  const MapPickerResult({
    required this.latitude,
    required this.longitude,
    required this.address,
    this.city,
    this.neighborhood,
  });

  final double latitude;
  final double longitude;
  final String address;
  final String? city;
  final String? neighborhood;
}
