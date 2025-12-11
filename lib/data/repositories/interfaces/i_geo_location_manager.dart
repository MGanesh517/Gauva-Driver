import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gauva_driver/data/models/common_response.dart';

abstract class IGeoLocationManager {
  Future<bool> checkLocationPermission();
  Future<LatLng?> getUserLocation();
  Stream<LatLng> locationStream();
  Future<CommonResponse> saveDriverLocation(LatLng latLng, {required Ref ref});
}
