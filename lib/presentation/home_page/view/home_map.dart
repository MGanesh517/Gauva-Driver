import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gauva_driver/presentation/booking/provider/home_providers.dart';

import '../../../common/loading_view.dart';
import '../../../data/models/hive_models/user_hive_model.dart';
import '../../../data/services/local_storage_service.dart';
import '../../booking/provider/driver_providers.dart';

class HomeMap extends ConsumerStatefulWidget {
  const HomeMap({super.key});

  @override
  ConsumerState<HomeMap> createState() => _HomeMapState();
}

class _HomeMapState extends ConsumerState<HomeMap> {
  @override
  void initState() {
    super.initState();
    ref.read(driverStatusNotifierProvider.notifier);
  }

  void _onMapCreated(GoogleMapController controller) async {
    final homeState = ref.read(bookingNotifierProvider);
    ref.read(bookingNotifierProvider.notifier).setMapController(controller);
    final UserHiveModel? userHiveModel = await LocalStorageService().getSavedUser();
    if (homeState.currentLocation != null) {
      final int radius = ref.read(bookingNotifierProvider.notifier).getRadiusInKm(userHiveModel?.radiusInMeter);
      final double zoomLevel = ref.read(bookingNotifierProvider.notifier).getZoomLevel(radius * 1000);

      controller.animateCamera(CameraUpdate.newLatLngZoom(homeState.currentLocation!, zoomLevel));
    }
  }

  @override
  Widget build(BuildContext context) {
    final driverStatusState = ref.watch(driverStatusNotifierProvider);
    return Stack(
      children: [
        Consumer(
          builder: (context, ref, _) {
            final homeState = ref.watch(bookingNotifierProvider);
            return homeState.currentLocation == null
                ? const LoadingView()
                : GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: homeState.currentLocation ?? const LatLng(0.0, 0.0),
                      zoom: 18.0,
                    ),
                    myLocationButtonEnabled: false,
                    compassEnabled: false,
                    zoomControlsEnabled: false,
                    rotateGesturesEnabled: false,
                    markers: homeState.markers.isNotEmpty ? {homeState.markers.first} : {},
                    circles: driverStatusState.maybeMap(
                      orElse: () => {},
                      online: (value) => homeState.circles,
                      offline: (value) => {},
                      onTrip: (value) => {},
                    ),
                  );
          },
        ),
      ],
    );
  }
}
