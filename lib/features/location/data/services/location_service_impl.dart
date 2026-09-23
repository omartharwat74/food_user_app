import 'package:geolocator/geolocator.dart';
import 'package:food_user_app/features/location/domain/services/location_service.dart';

class LocationServiceImpl implements LocationService {
  @override
  Future<Position> getCurrentLocation() async {
    final isEnabled = await isLocationServiceEnabled();
    if (!isEnabled) {
      throw Exception('Location services are disabled');
    }
    final permission = await requestLocationPermission();
    if (!permission) {
      throw Exception('Location permission denied');
    }
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  @override
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  @override
  Future<bool> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }
}
