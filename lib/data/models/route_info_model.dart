import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteInfo {
  final List<LatLng> polylinePoints;
  final int distanceInMeters;
  final String distanceText;
  final int durationInSeconds;
  final String durationText;

  RouteInfo({
    required this.polylinePoints,
    required this.distanceInMeters,
    required this.distanceText,
    required this.durationInSeconds,
    required this.durationText,
  });
}
