import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/core/widgets/is_ios.dart';
import 'package:gauva_driver/presentation/home_page/provider/home_notifier_provider.dart';
import 'package:gauva_driver/presentation/home_page/widgets/online_offline_page.dart';
import 'package:gauva_driver/presentation/home_page/widgets/top.dart';
import 'package:vibration/vibration.dart';

import '../../../core/utils/is_dark_mode.dart';
import '../../../data/services/local_storage_service.dart';
import '../../booking/provider/driver_providers.dart';
import '../../booking/provider/home_providers.dart';
import '../../booking/provider/ride_providers.dart';
import '../../booking/provider/websocket_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  StreamSubscription<Map<String, dynamic>>? _rideRequestSubscription;

  @override
  void initState() {
    super.initState();
    ref.read(bookingNotifierProvider.notifier).initialize();
    Future.microtask(() {
      ref.read(homeProvider.notifier).getDashboard();
      // ref.read(tripActivityNotifierProvider.notifier).checkTripActivity();

      // Setup WebSocket listener - try immediately, then retry if needed
      _setupWebSocketListener();
    });
  }

  void _setupWebSocketListener() {
    try {
      // Get the websocket notifier
      final webSocketNotifier = ref.read(webSocketNotifierProvider.notifier);

      print('🔌 HomePage: Setting up WebSocket listener for new ride requests...');

      // Check connection status
      final isConnected = webSocketNotifier.isConnected;
      print('🔌 HomePage: WebSocket connection status: $isConnected');

      if (!isConnected) {
        print('⚠️ HomePage: WebSocket not connected. Will retry in 3 seconds...');
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            _setupWebSocketListener();
          }
        });
        return;
      }

      // Cancel any existing subscription
      _rideRequestSubscription?.cancel();

      // Listen to new ride request stream
      print('🔌 HomePage: Creating subscription to newRideRequestStream...');
      print('🔌 HomePage: Stream reference: ${webSocketNotifier.newRideRequestStream}');

      _rideRequestSubscription = webSocketNotifier.newRideRequestStream.listen(
        (data) {
          print('🆕 ==========================================');
          print('🆕 HomePage: NEW RIDE REQUEST STREAM EVENT!');
          print('🆕 HomePage: Data received in listener callback');
          print('📦 Full Data: $data');
          print('📦 Data Type: ${data.runtimeType}');
          print('📦 Data Keys: ${data.keys.toList()}');

          // Extract ride ID from the WebSocket message
          // The data structure might be: {rideId: 19, ride: {...}} or {id: 19, ...}
          final rideId =
              data['rideId'] ??
              data['id'] ??
              data['orderId'] ??
              data['order_id'] ??
              data['ride']?['id'] ??
              data['ride']?['rideId'];

          if (rideId != null) {
            print('✅ HomePage: Extracted ride ID: $rideId');
            print('✅ HomePage: Triggering order request flow for ride $rideId');

            // Play sound when new ride request arrives
            _playRideRequestSound();

            // Use the same flow as Pusher to ensure consistency
            // This will start the timer, reset state, show dialogue, and fetch order details
            ref
                .read(driverStatusNotifierProvider.notifier)
                .orderRequest(data: {'order_id': rideId is int ? rideId : int.tryParse(rideId.toString()) ?? rideId});
          } else {
            print('⚠️ HomePage: No ride ID found in WebSocket data');
            print('⚠️ HomePage: Available keys: ${data.keys.toList()}');
            print('⚠️ HomePage: Full data structure: $data');
          }
          print('🆕 ==========================================');
        },
        onError: (error) {
          print('❌ HomePage: Error in WebSocket stream: $error');
          // Try to re-setup listener on error
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              _setupWebSocketListener();
            }
          });
        },
        onDone: () {
          print('ℹ️ HomePage: WebSocket stream closed - attempting to reconnect listener...');
          // Try to re-setup listener when stream closes
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              _setupWebSocketListener();
            }
          });
        },
        cancelOnError: false, // Keep listening even on errors
      );

      print('✅ HomePage: WebSocket listener setup complete - continuously listening for new ride requests');
      print('✅ HomePage: Listener is active and will receive events from "drivers:available" room');
      print('✅ HomePage: Subscription created: $_rideRequestSubscription');
      print('✅ HomePage: Subscription isPaused: ${_rideRequestSubscription?.isPaused ?? 'N/A'}');
      print('✅ HomePage: Stream is ready - waiting for new_ride_request events...');
      print('✅ HomePage: ✅✅✅ LISTENER IS ACTIVE AND READY ✅✅✅');

      // Verify subscription is not null
      if (_rideRequestSubscription == null) {
        print('❌ HomePage: CRITICAL ERROR - Subscription is null after creation!');
      } else {
        print('✅ HomePage: Subscription verification passed - listener is active');
      }
    } catch (e) {
      print('❌ HomePage: Error setting up WebSocket listener: $e');
      // Retry on error
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          _setupWebSocketListener();
        }
      });
    }
  }

  /// Play sound when new ride request arrives
  void _playRideRequestSound() async {
    try {
      print('🔊 HomePage: Playing ride request sound...');
      if (isIos()) {
        // iOS: Use system sound
        FlutterRingtonePlayer().play(
          android: AndroidSounds.notification,
          ios: IosSounds.horn,
          looping: false,
          volume: 1.0,
        );
      } else {
        // Android: Use Rapidosound.mp3 from assets
        FlutterRingtonePlayer().play(fromAsset: 'assets/Rapidosound.mp3', looping: false, volume: 1.0, asAlarm: true);
      }

      // Vibrate phone
      await _vibratePhone();
    } catch (e) {
      print('❌ HomePage: Error playing ride request sound: $e');
    }
  }

  /// Vibrate phone when ride request arrives
  Future<void> _vibratePhone() async {
    try {
      // Check if vibration is enabled from local storage
      final isVibrationEnabled = await LocalStorageService().getVibration();

      if (isVibrationEnabled) {
        // If vibration is enabled, vibrate the phone
        if (await Vibration.hasCustomVibrationsSupport()) {
          Vibration.vibrate(duration: 2000); // Vibrate for 2 seconds if custom vibrations are supported
        } else {
          Vibration.vibrate(); // Default vibration
          await Future.delayed(const Duration(milliseconds: 500)); // Pause for 500ms
          Vibration.vibrate(); // Vibrate again
        }
      }
    } catch (e) {
      print('❌ HomePage: Error vibrating phone: $e');
    }
  }

  @override
  void dispose() {
    _rideRequestSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        decoration: BoxDecoration(color: isDarkMode() ? Colors.black : Colors.white),
        child: Column(children: [top(context), Gap(12.h), onlineOfflinePage(context)]),
      ),
    ),
  );
}
