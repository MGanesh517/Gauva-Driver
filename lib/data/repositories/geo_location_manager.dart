import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gauva_driver/core/config/api_endpoints.dart';
import 'package:gauva_driver/data/models/common_response.dart';
import 'package:gauva_driver/data/repositories/interfaces/i_geo_location_manager.dart';
import 'package:gauva_driver/presentation/auth/provider/auth_providers.dart';

class GeoLocationManager implements IGeoLocationManager {
  final Location _location = Location();

  @override
  Future<bool> checkLocationPermission() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return false;
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return false;
    }
    return true;
  }

  @override
  Future<LatLng?> getUserLocation() async {
    if (!await checkLocationPermission()) return null;
    final userLocation = await _location.getLocation();
    return LatLng(userLocation.latitude!, userLocation.longitude!);
  }

  @override
  Stream<LatLng> locationStream() =>
      _location.onLocationChanged.map((locationData) => LatLng(locationData.latitude!, locationData.longitude!));

  @override
  Future<CommonResponse> saveDriverLocation(LatLng latLng, {required Ref ref}) async {
    try {
      final response = await ref
          .read(dioClientProvider)
          .dio
          .post(
            ApiEndpoints.driverLocationsUpdate,
            data: {
              'location': [latLng.latitude, latLng.longitude],
            },
          );
      return CommonResponse.fromJson(response.data);
    } catch (e) {
      return CommonResponse.fromJson({'success': false, 'message': e.toString()});
    }
  }
}
