import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gauva_driver/gen/assets.gen.dart';
import 'package:gauva_driver/presentation/booking/provider/home_providers.dart';

import '../../../data/models/ride_history/ride_history_state.dart';

class RideDetailHistoryNotifier extends StateNotifier<RideHistoryState> {
  final Ref ref;

  RideDetailHistoryNotifier(this.ref) : super(RideHistoryState.empty());

  void setPoints(LatLng pickup, LatLng drop) async {
    removeMarkers();
    final notifier = ref.read(bookingNotifierProvider.notifier);
    final markers = {
      Marker(
        markerId: const MarkerId('pickup'),
        position: pickup,
        icon: BitmapDescriptor.bytes(await notifier.createCircle()),
      ),
      Marker(
        markerId: const MarkerId('drop'),
        position: drop,
        // icon: BitmapDescriptor.defaultMarkerWithHue(50)
        icon: await BitmapDescriptor.asset(
          const ImageConfiguration(size: Size(90, 90)),
          Assets.images.locationPinMarker.path,
        ),
        anchor: const Offset(0.0, 1.0),
      ),
    };

    final polyline = Polyline(
      polylineId: const PolylineId('route'),
      points: [pickup, drop],
      color: const Color(0xFF7B61FF),
      width: 4,
    );

    state = state.copyWith(markers: markers, polyLines: {polyline});
  }

  void removeMarkers() {
    state = state.copyWith(markers: {});
  }
}
