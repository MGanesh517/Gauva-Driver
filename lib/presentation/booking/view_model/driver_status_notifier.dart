import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gauva_driver/core/state/app_state.dart';
import 'package:gauva_driver/core/state/driver_status_state.dart';
import 'package:gauva_driver/core/utils/helpers.dart';
import 'package:gauva_driver/data/models/driver_radius_update_response/driver_radius_update_response.dart';
import 'package:gauva_driver/data/repositories/interfaces/status_repo_interface.dart';
import 'package:gauva_driver/presentation/booking/view_model/reverse_timer_notifier.dart';
import 'package:gauva_driver/presentation/home_page/widgets/order_request_dialogue.dart';

import '../../../core/enums/driver_status.dart';
import '../../../data/services/local_storage_service.dart';
import '../../home_page/widgets/online_offline_switch.dart';
import '../provider/home_providers.dart';
import '../provider/location_provider.dart';
import '../provider/pusher_provider.dart';
import '../provider/ride_providers.dart';
import '../provider/websocket_provider.dart';

class DriverStatusNotifier extends StateNotifier<DriverStatusState> {
  final IStatusRepo statusRepo;
  final Ref ref;
  DriverStatusNotifier(this.ref, this.statusRepo) : super(const DriverStatusState.initial()) {
    initialize();
  }

  void initialize() async {
    await LocalStorageService().getOnlineOffline() ? online() : offline();
  }

  void onTrip() {
    state = const DriverStatusState.onTrip();
  }

  void offline() {
    print('📴 Driver: Going OFFLINE...');
    state = const DriverStatusState.offline();
    isOnlineNotifier.value = false;
    ref.read(pusherNotifierProvider.notifier).disconnect();
    // Disconnect WebSocket
    ref.read(webSocketNotifierProvider.notifier).disconnect();
    print('✅ Driver: OFFLINE');
  }

  void online() async {
    print('🟢 Driver: Going ONLINE...');
    state = const DriverStatusState.online();
    isOnlineNotifier.value = true;

    // Setup Pusher
    ref.read(pusherNotifierProvider.notifier).setupPusherListeners();

    // Connect WebSocket
    await ref.read(webSocketNotifierProvider.notifier).setupWebSocketListeners();

    print('✅ Driver: ONLINE');
  }

  Future<void> orderRequest({required Map<String, dynamic> data}) async {
    ref.read(reverseTimerProvider.notifier).startTimer();
    final orderNotifier = ref.read(rideOrderNotifierProvider.notifier)..resetStateAfterDelay();
    orderRequestDialogue();
    await orderNotifier.orderDetails(orderId: data['order_id']);
    try {
      await ref.read(bookingNotifierProvider.notifier).updateMapZoom();
    } catch (e) {
      print('⚠️ Error updating map zoom for order request: $e');
    }

    state = DriverStatusState.orderRequest(data);
  }

  Future<void> updateOnlineStatus(String status) async {
    state = DriverStatusState.loading();
    final result = await statusRepo.updateOnlineStatus(status: status);
    result.fold(
      (failure) {
        state = const DriverStatusState.offline();
        showNotification(message: failure.message);
      },
      (data) async {
        // Save user data if present in response
        if (data.data != null) {
          print('💾 Driver Status: Saving user data from status update...');
          await LocalStorageService().saveUser(data: data.data!.toJson());
        }

        // Check new API format (isOnline) or old format (data.status)
        final bool isOnlineFromResponse =
            data.isOnline ?? (data.data?.status?.toLowerCase() == DriverStatus.online.name);

        print('🔄 Status update - isOnline from response: $isOnlineFromResponse');
        print('🔄 Status update - data.isOnline: ${data.isOnline}');
        print('🔄 Status update - data.data?.status: ${data.data?.status}');

        if (!isOnlineFromResponse) {
          // Driver is offline
          print('📴 Setting driver to OFFLINE');
          await LocalStorageService().setOnlineOffline(false);
          isOnlineNotifier.value = false;
          ref.read(pusherNotifierProvider.notifier).disconnect();
          // Disconnect WebSocket
          ref.read(webSocketNotifierProvider.notifier).disconnect();
          WidgetsBinding.instance.addPostFrameCallback((v) async {
            try {
              ref.read(bookingNotifierProvider.notifier).resetToInitial(enablePusher: false);
              // Wrap map operations in try-catch to handle disposed controllers
              try {
                await ref.read(bookingNotifierProvider.notifier).resetMapZoom();
              } catch (e) {
                print('⚠️ Error resetting map zoom when going offline: $e');
              }
              ref.read(locationNotifierProvider.notifier).stopTracking();
            } catch (e) {
              print('⚠️ Error during offline cleanup: $e');
            }
          });
          state = const DriverStatusState.offline();
          print('✅ State set to OFFLINE');
        } else {
          // Driver is online
          print('🟢 Setting driver to ONLINE');
          isOnlineNotifier.value = true;
          state = const DriverStatusState.online();
          ref.read(pusherNotifierProvider.notifier).setupPusherListeners();
          // Connect WebSocket
          await ref.read(webSocketNotifierProvider.notifier).setupWebSocketListeners();
          ref.read(locationNotifierProvider.notifier).startTracking();
          await LocalStorageService().setOnlineOffline(true);
          print('✅ State set to ONLINE');
        }
      },
    );
  }
}

class DriverRadiusNotifier extends StateNotifier<AppState<DriverRadiusUpdateResponse>> {
  final IStatusRepo statusRepo;
  final Ref ref;
  DriverRadiusNotifier(this.ref, this.statusRepo) : super(const AppState.initial());

  Future<void> updateRadius(int radius) async {
    state = const AppState.loading();
    final result = await statusRepo.updateRadius(radius: radius);
    result.fold((failure) => state = AppState.error(failure), (data) async {
      await LocalStorageService().saveUser(data: data.data?.user?.toJson());
      state = AppState.success(data);
    });
  }
}
