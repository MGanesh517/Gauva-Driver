 import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gauva_driver/core/errors/failure.dart';
import 'package:gauva_driver/core/state/app_state.dart';
import 'package:gauva_driver/core/theme/color_palette.dart';
import 'package:gauva_driver/core/utils/helpers.dart';
import 'package:gauva_driver/data/models/common_response.dart';
import 'package:gauva_driver/data/models/order_response/order_model/points/points.dart';
import 'package:gauva_driver/data/models/route_info_model.dart';
import 'package:gauva_driver/presentation/booking/provider/home_providers.dart';
import '../../../data/repositories/interfaces/way_points_repo_interface.dart';
import '../provider/way_point_list_provider.dart';

class RouteNotifier extends StateNotifier<AppState<RouteInfo>> {
  final IGoogleAPIRepo googleAPIRepo;
  final Ref ref;

  RouteNotifier({required this.ref, required this.googleAPIRepo}) : super(const AppState.initial());

  Future<void> fetchRoutesDetail(
    Points? points, {
    bool sendDataToRider = false,
    LatLng? pickUpPoint,
    int? orderId,
  }) async {
    state = const AppState.loading();

    final result = await googleAPIRepo.fetchWayPoints(waypoints: points);
    result.fold(
      (error) {
        state = AppState.error(error);
      },
      (v) {
        if (v.polylinePoints.length < 2) {
          return state = AppState.error(Failure(message: 'Invalid route data'));
        }

        final polyLine = {
          Polyline(
            polylineId: const PolylineId('route'),
            color: ColorPalette.primary50,
            width: 5,
            points: v.polylinePoints,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
          ),
        };
        if (sendDataToRider) {
          final pickup = pickUpPoint;
          final lat = (points?.pickupLocation?.firstOrNull)?.toDouble();
          final lng = (points?.pickupLocation?.lastOrNull)?.toDouble();

          final latD = (points?.dropLocation?.firstOrNull)?.toDouble();
          final lngD = (points?.dropLocation?.lastOrNull)?.toDouble();
          final current = (lat != null && lng != null) ? LatLng(lat, lng) : null;
          final destination = (latD != null && lngD != null) ? LatLng(latD, lngD) : null;
          final totalDistance = v.distanceInMeters;
          final polyline = v.polylinePoints;

          calculateRouteProgress(
            ref,
            orderId: orderId,
            pickup: pickup,
            current: current,
            totalDistanceInMeters: totalDistance,
            polylinePoints: polyline,
            routeInfo: v,
            destination: destination,
          );
        }
        ref.read(bookingNotifierProvider.notifier).updatePolyLines(polyLine);
        state = AppState.success(v);
      },
    );
  }
}

class SendTravelInfoNotifier extends StateNotifier<AppState<CommonResponse>> {
  final IGoogleAPIRepo googleAPIRepo;
  final Ref ref;
  SendTravelInfoNotifier({required this.ref, required this.googleAPIRepo}) : super(const AppState.initial());

  Future<void> sendTravelInfo({required Map<String, dynamic> info}) async {
    final result = await googleAPIRepo.sendTravelInfo(info: info);

    result.fold(
      (error) {
        state = AppState.error(error);
        showNotification(message: error.message);
      },
      (v) {
        state = AppState.success(v);
      },
    );
  }
}

double calculateHaversineDistance(LatLng start, LatLng end) {
  const R = 6371000; // Earth's radius in meters
  final dLat = _toRadians(end.latitude - start.latitude);
  final dLng = _toRadians(end.longitude - start.longitude);

  final a =
      sin(dLat / 2) * sin(dLat / 2) +
      cos(_toRadians(start.latitude)) * cos(_toRadians(end.latitude)) * sin(dLng / 2) * sin(dLng / 2);

  final c = 2 * atan2(sqrt(a), sqrt(1 - a));

  return R * c;
}

double _toRadians(double degree) => degree * pi / 180;

/// Calculate route progress between pickup -> current based on total distance.
/// Returns progress [0.0 - 1.0]. If any input is null or invalid, returns 0.0.
void calculateRouteProgress(
  Ref ref, {
  required int? orderId,
  required LatLng? pickup,
  required LatLng? current,
  required int? totalDistanceInMeters,
  required List<LatLng>? polylinePoints,
  required RouteInfo routeInfo,
  required LatLng? destination,
}) {
  if (pickup == null || current == null || totalDistanceInMeters == null || totalDistanceInMeters <= 0) {
    return;
  }

  final distanceTravelled = calculateHaversineDistance(pickup, current);
  final progress = (distanceTravelled / totalDistanceInMeters).clamp(0.0, 1.0);
  ref.read(routeProgressProvider.notifier).state = progress;

  // Commented out: API endpoint not available on server (returns 500 error)
  // ref
  //     .read(sendTravelInfoProvider.notifier)
  //     .sendTravelInfo(
  //       info: {
  //         'order_id': orderId,
  //         'minute': routeInfo.durationText,
  //         'distance': routeInfo.distanceText,
  //         'progress': progress,
  //         'destination': destination,
  //         'driver_location': current,
  //         'polyline': routeInfo.polylinePoints,
  //       },
  //     );
}
