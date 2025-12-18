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
    // Check if widget is still mounted before using ref
    if (!mounted) return;

    final homeState = ref.read(bookingNotifierProvider);
    final bookingNotifier = ref.read(bookingNotifierProvider.notifier);

    // Set map controller immediately (synchronous operation)
    bookingNotifier.setMapController(controller);

    // Store current location before async call
    final currentLocation = homeState.currentLocation;

    // Perform async operation
    final UserHiveModel? userHiveModel = await LocalStorageService().getSavedUser();

    // Check if widget is still mounted after async operation
    if (!mounted) return;

    if (currentLocation != null) {
      // Read notifier again after async operation (with mounted check)
      final int radius = bookingNotifier.getRadiusInKm(userHiveModel?.radiusInMeter);
      final double zoomLevel = bookingNotifier.getZoomLevel(radius * 1000);

      try {
        await controller.animateCamera(CameraUpdate.newLatLngZoom(currentLocation, zoomLevel));
      } catch (e) {
        print('⚠️ Error animating camera in home_map: $e');
        // Silently fail - map controller might be disposed or platform channel disconnected
      }
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
