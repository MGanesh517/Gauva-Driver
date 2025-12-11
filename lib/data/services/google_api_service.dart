import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gauva_driver/data/models/order_response/order_model/points/points.dart';

import '../../core/config/api_endpoints.dart';
import '../../domain/interfaces/google_api_service_interface.dart';
import 'api/dio_client.dart';

class GoogleApiService implements IGoogleApiService {
  final DioClient dioClient;
  GoogleApiService({required this.dioClient});
  final String apiKey = dotenv.env['GOOGLE_MAPS_API_KEY']!;

  @override
  Future<Response> fetchWayPoints({required Points? waypoints}) async {
    // Ensure the list has 2 (origin, destination) or 3 (origin, stop, destination) points
    if ((waypoints?.pickupLocation == null || waypoints?.dropLocation == null) ||
        (waypoints?.pickupLocation?.length != 2 || waypoints?.dropLocation?.length != 2)) {
      throw ArgumentError('Pickup and drop locations must contain valid coordinates.');
    }

    // Extract origin and destination
    final LatLng origin = LatLng(waypoints!.pickupLocation![0].toDouble(), waypoints.pickupLocation![1].toDouble());
    final LatLng destination = LatLng(waypoints.dropLocation![0].toDouble(), waypoints.dropLocation![1].toDouble());

    // Extract optional stop point(s) only if waypoints length is 3
    final List<LatLng> stopPoints = [];
    if (waypoints.waitLocation != null && waypoints.waitLocation!.isNotEmpty) {
      final LatLng stop = LatLng(waypoints.waitLocation![0].toDouble(), waypoints.waitLocation![1].toDouble());
      stopPoints.add(stop);
    }

    // Construct the waypoints query string
    final String wayPointsString = stopPoints.isNotEmpty
        ? "&waypoints=${stopPoints.map((e) => "${e.latitude},${e.longitude}").join('|')}"
        : '';

    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}$wayPointsString&mode=driving&key=$apiKey';

    return dioClient.dio.get(url);
  }

  @override
  Future<Response> sendTravelInfo({required Map<String, dynamic> info}) async =>
      await dioClient.dio.post(ApiEndpoints.sendTravelInfo, data: info);
}
