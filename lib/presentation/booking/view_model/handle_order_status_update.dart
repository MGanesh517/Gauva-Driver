import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gauva_driver/core/enums/booking_status.dart';
import 'package:gauva_driver/core/utils/set_status_bar_color.dart';
import 'package:gauva_driver/presentation/booking/provider/driver_providers.dart';
import 'package:gauva_driver/presentation/booking/provider/location_provider.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/services/navigation_service.dart';
import '../provider/home_providers.dart';
import '../provider/pusher_provider.dart';

void handleOrderStatusUpdate({
  required String status,
  required int? orderId,
  required Ref ref,
  bool fromPusher = false,
  String? payMethod,
}) {
  final tripStatusNotifier = ref.read(ontripStatusNotifier.notifier);

  void handlePostPusherActions() {
    ref.read(pusherNotifierProvider.notifier).setupPusherListeners();
    ref.read(bookingNotifierProvider.notifier);
    // ..read(chatNotifierProvider.notifier);
    setStatusBarColor(change: true);
    NavigationService.pushNamedAndRemoveUntil(AppRoutes.bookingPage);
  }

  switch (status) {
    case 'accepted':
      tripStatusNotifier.updateOnTripStatus(status: BookingStatus.goForPickup, fromSplash: true);
      break;

    case 'go_to_pickup':
      tripStatusNotifier.updateOnTripStatus(status: BookingStatus.arrivedAtPickupPoint, fromSplash: true);
      break;

    case 'confirm_arrival':
      tripStatusNotifier.updateOnTripStatus(status: BookingStatus.pickupConfirmed, fromSplash: true);
      break;

    case 'picked_up':
      tripStatusNotifier.updateOnTripStatus(status: BookingStatus.rideStarted, fromSplash: true);
      break;

    case 'start_ride':
      tripStatusNotifier.updateOnTripStatus(status: BookingStatus.headingToDestination, fromSplash: true);
      break;

    case 'dropped_off':
      ref.read(locationNotifierProvider.notifier).stopTracking();
      tripStatusNotifier.updateOnTripStatus(status: BookingStatus.payment, fromSplash: true);
      break;

    case 'completed':
      if (!fromPusher) {
        NavigationService.pushNamedAndRemoveUntil(AppRoutes.dashboard);
      }
      break;
  }

  if (!fromPusher && status != 'completed') {
    handlePostPusherActions();
  }
}
