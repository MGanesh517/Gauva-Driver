import 'package:dartz/dartz.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gauva_driver/data/models/common_response.dart';
import 'package:gauva_driver/data/models/order_response/order_model/points/points.dart';

import '../../core/errors/failure.dart';
import '../../domain/interfaces/google_api_service_interface.dart';
import '../models/route_info_model.dart';
import 'base_repository.dart';
import 'interfaces/way_points_repo_interface.dart';

class GoogleAPIRepoImpl extends BaseRepository implements IGoogleAPIRepo {
  final IGoogleApiService _googleApiService;

  GoogleAPIRepoImpl(this._googleApiService);

  @override
  Future<Either<Failure, RouteInfo>> fetchWayPoints({required Points? waypoints}) async => await safeApiCall(() async {
    final PolylinePoints polylinePoints0 = PolylinePoints();
    final response = await _googleApiService.fetchWayPoints(waypoints: waypoints);
    final data = response.data;

    if (data['status'] == 'OK') {
      final route = data['routes'][0];

      // Initialize variables for total distance and duration
      num totalDistanceInMeters = 0;
      num totalDurationInSeconds = 0;

      // Calculate total distance and duration from legs
      for (var leg in route['legs']) {
        totalDistanceInMeters += leg['distance']['value'];
        totalDurationInSeconds += leg['duration']['value'];
      }

      // Decode the overview polyline once
      final String encodedPolyline = route['overview_polyline']['points'];
      final List<PointLatLng> decodedPoints = polylinePoints0.decodePolyline(encodedPolyline);
      final List<LatLng> polylineCoordinates = decodedPoints.map((e) => LatLng(e.latitude, e.longitude)).toList();

      // Build and return RouteInfo
      final double totalDistanceInKilometers = totalDistanceInMeters / 1000;
      final String totalDistanceText = totalDistanceInKilometers.toStringAsFixed(1);
      final String totalDurationText = '${totalDurationInSeconds ~/ 60} minutes';

      return RouteInfo(
        polylinePoints: polylineCoordinates,
        distanceInMeters: totalDistanceInMeters.toInt(),
        distanceText: '$totalDistanceText km',
        durationInSeconds: totalDurationInSeconds.toInt(),
        durationText: totalDurationText,
      );
    }

    throw Exception('Failed to fetch directions');
  });

  @override
  Future<Either<Failure, CommonResponse>> sendTravelInfo({required Map<String, dynamic> info}) async =>
      await safeApiCall(() async {
        final response = await _googleApiService.sendTravelInfo(info: info);
        return CommonResponse.fromJson(response.data);
      });
}
