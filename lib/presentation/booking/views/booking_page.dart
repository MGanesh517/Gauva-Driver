import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gauva_driver/common/loading_view.dart';
import 'package:gauva_driver/core/utils/exit_app_dialogue.dart';
import 'package:gauva_driver/core/widgets/location_permission_wrapper.dart';

import '../../../core/routes/app_routes.dart';
import '../provider/driver_providers.dart';
import '../provider/home_providers.dart';
import '../widgets/driver_status_sheet.dart';

class BookingPage extends ConsumerStatefulWidget {
  const BookingPage({super.key});

  @override
  ConsumerState<BookingPage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<BookingPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  BitmapDescriptor? pickupIcon;

  void _onMapCreated(GoogleMapController controller) async {
    final homeState = ref.read(bookingNotifierProvider);
    ref.read(bookingNotifierProvider.notifier).setMapController(controller);
    if (homeState.currentLocation != null) {
      controller.animateCamera(CameraUpdate.newLatLngZoom(homeState.currentLocation!, 16));
    }
  }

  @override
  Widget build(BuildContext context) {
    final driverStatusState = ref.watch(driverStatusNotifierProvider);
    final bookingState = ref.watch(bookingNotifierProvider);
    return ExitAppWrapper(
      child: LocationPermissionWrapper(
        pageName: AppRoutes.bookingPage,
        child: Scaffold(
          key: scaffoldKey,
          resizeToAvoidBottomInset: false,
          body: bookingState.currentLocation == null
              ? const LoadingView()
              : Stack(
                  children: [
                    GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: bookingState.currentLocation ?? const LatLng(0.0, 0.0),
                        zoom: 18.0,
                      ),
                      myLocationButtonEnabled: false,
                      compassEnabled: false,
                      zoomControlsEnabled: false,
                      rotateGesturesEnabled: false,
                      trafficEnabled: true,

                      markers: bookingState.markers,
                      polylines: bookingState.polylines,
                      circles: driverStatusState.maybeMap(
                        orElse: () => {},
                        online: (value) => bookingState.circles,
                        offline: (value) => {},
                        onTrip: (value) => {},
                      ),
                    ),

                    const Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: DriverStatusSheet(
                        // controller: bookingMapController,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
