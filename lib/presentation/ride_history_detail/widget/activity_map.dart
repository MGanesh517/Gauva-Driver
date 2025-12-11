import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gauva_driver/core/utils/is_dark_mode.dart';
import 'package:gauva_driver/data/models/order_response/order_model/order/order.dart';
import 'package:gauva_driver/presentation/ride_history_detail/provider/ride_history_provider.dart';

final Completer<GoogleMapController> _controller = Completer();
bool _cameraMoved = false;

Widget activityMap(BuildContext context, WidgetRef ref, Order? order) {
  final List<num> pick = order?.points?.pickupLocation ?? [];
  final List<num> drop = order?.points?.dropLocation ?? [];

  final LatLng? pickUpLocation = pick.length == 2 ? LatLng(pick.first.toDouble(), pick.last.toDouble()) : null;
  final LatLng? dropLocation = drop.length == 2 ? LatLng(drop.first.toDouble(), drop.last.toDouble()) : null;

  final state = ref.watch(rideDetailHistoryProvider);

  // Set markers only once
  if (pickUpLocation != null && dropLocation != null && state.markers.isEmpty) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(rideDetailHistoryProvider.notifier).setPoints(pickUpLocation, dropLocation);
    });
  }

  // Move camera after controller and markers are ready
  if (!_cameraMoved && _controller.isCompleted && state.markers.length >= 2) {
    _moveCamera(state.markers.first.position, state.markers.last.position);
    _cameraMoved = true;
  }

  return Container(
    height: 172.h,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(6.r),
      border: Border.all(color: isDarkMode() ? Colors.black12 : Colors.white, width: 4.w),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(6.r),
      child: GoogleMap(
        initialCameraPosition: CameraPosition(target: pickUpLocation ?? const LatLng(0, 0), zoom: 14, tilt: 20),
        markers: state.markers,
        polylines: state.polyLines,
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
        onMapCreated: (controller) {
          if (!_controller.isCompleted) {
            _controller.complete(controller);
          }
        },
      ),
    ),
  );
}

Future<void> _moveCamera(LatLng pickup, LatLng drop) async {
  final controller = await _controller.future;

  // If pickup and drop are the same point, just zoom in
  if (pickup == drop) {
    await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: pickup, zoom: 14)));
    return;
  }

  // Otherwise fit both points in bounds
  final bounds = LatLngBounds(
    southwest: LatLng(
      pickup.latitude < drop.latitude ? pickup.latitude : drop.latitude,
      pickup.longitude < drop.longitude ? pickup.longitude : drop.longitude,
    ),
    northeast: LatLng(
      pickup.latitude > drop.latitude ? pickup.latitude : drop.latitude,
      pickup.longitude > drop.longitude ? pickup.longitude : drop.longitude,
    ),
  );

  await controller.animateCamera(
    CameraUpdate.newLatLngBounds(bounds, 20), // Increased padding for better fit
  );
}
