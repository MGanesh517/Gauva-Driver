import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gauva_driver/data/services/driver_websocket_service.dart';
import 'package:gauva_driver/data/services/local_storage_service.dart';
import 'package:gauva_driver/presentation/profile/provider/profile_providers.dart';

import 'package:gauva_driver/presentation/splash/provider/app_config_providers.dart';

class WebSocketNotifier extends StateNotifier<void> {
  final Ref ref;
  late final DriverWebSocketService _driverWebSocketService;

  WebSocketNotifier(this.ref) : super(null) {
    _driverWebSocketService = DriverWebSocketService(configService: ref.read(configServiceProvider));
  }

  /// Setup WebSocket and subscribe to necessary topics
  Future<void> setupWebSocketListeners() async {
    try {
      print('🔌 WebSocket Notifier: Setting up WebSocket listeners...');

      // Get JWT token first
      final token = await LocalStorageService().getToken();
      if (token == null || token.isEmpty) {
        print('❌ WebSocket Notifier: No token found');
        return;
      }

      // Get driver ID with retry mechanism (in case user data is still being saved)
      int? driverId = await _getDriverIdWithRetry();

      // Fallback: If driver ID is still null, try to fetch profile from API
      if (driverId == null) {
        print('⚠️ WebSocket Notifier: Driver ID missing after retries. Attempting to fetch profile...');
        await ref.read(driverDetailsNotifierProvider.notifier).getDriverDetails();

        // Try getting ID one more time after fetch
        driverId = await LocalStorageService().getUserId();
      }

      if (driverId == null) {
        print('❌ WebSocket Notifier: No driver ID found after fallback. Cannot connect.');
        return;
      }

      print('🔌 WebSocket Notifier: Driver ID: $driverId');
      print(
        '🔑 WebSocket Notifier: Token found (length: ${token.length}, first 20 chars: ${token.substring(0, token.length > 20 ? 20 : token.length)}...)',
      );

      // Initialize driver WebSocket service
      await _driverWebSocketService.initializeDriver(jwtToken: token, driverId: driverId);

      print('✅ WebSocket Notifier: Driver WebSocket service initialized');
      print('✅ WebSocket Notifier: newRideRequestStream is ready for listeners');
      print('✅ WebSocket Notifier: Driver is in "drivers:available" room - will receive new_ride_request events');
    } catch (e, stackTrace) {
      print('❌ WebSocket Notifier: Error setting up listeners: $e');
      print('❌ WebSocket Notifier: Stack trace: $stackTrace');
    }
  }

  /// Get driver ID with retry mechanism
  Future<int?> _getDriverIdWithRetry({int maxRetries = 3, Duration delay = const Duration(milliseconds: 500)}) async {
    for (int i = 0; i < maxRetries; i++) {
      final driverId = await LocalStorageService().getUserId();
      if (driverId != null) {
        return driverId;
      }

      if (i < maxRetries - 1) {
        print('⏳ WebSocket Notifier: Retrying to get driver ID (attempt ${i + 1}/$maxRetries)...');
        await Future.delayed(delay);
      }
    }
    return null;
  }

  /// Join ride room
  Future<void> joinRideRoom(int rideId) async {
    _driverWebSocketService.joinRideRoom(rideId);
  }

  /// Leave ride room
  Future<void> leaveRideRoom() async {
    _driverWebSocketService.leaveRideRoom();
  }

  /// Start location tracking
  void startLocationTracking(int rideId) {
    _driverWebSocketService.startLocationTracking(rideId);
  }

  /// Stop location tracking
  void stopLocationTracking() {
    _driverWebSocketService.stopLocationTracking();
  }

  /// Send location update
  // void sendLocationUpdate(int rideId, double lat, double lng, {double? heading}) {
  //   _driverWebSocketService.sendLocationUpdate(
  //     rideId: rideId,
  //     driverId: int.tryParse(_driverWebSocketService.driverId ?? '0'),
  //     lat: lat,
  //     lng: lng,
  //     heading: heading,
  //   );
  // }

  /// Send chat message
  void sendChatMessage({
    required int rideId,
    required String senderId,
    required String senderName,
    required String receiverId,
    required String message,
  }) {
    _driverWebSocketService.sendMessageToRider(
      rideId: rideId,
      message: message,
      senderName: senderName,
      riderId: receiverId,
    );
  }

  /// Disconnect
  Future<void> disconnect() async {
    _driverWebSocketService.disconnect();
  }

  /// Get streams
  Stream<Map<String, dynamic>> get rideStatusStream => _driverWebSocketService.rideStatusStream;
  Stream<Map<String, dynamic>> get driverLocationStream => _driverWebSocketService.driverLocationStream;
  Stream<Map<String, dynamic>> get walletUpdateStream => _driverWebSocketService.walletUpdateStream;
  Stream<Map<String, dynamic>> get chatMessageStream => _driverWebSocketService.chatMessageStream;
  Stream<Map<String, dynamic>> get driverStatusStream => _driverWebSocketService.driverStatusStream;
  Stream<Map<String, dynamic>> get newRideRequestStream => _driverWebSocketService.newRideRequestStream;
  Stream<Map<String, dynamic>> get fleetStatsStream => _driverWebSocketService.fleetStatsStream;

  bool get isConnected => _driverWebSocketService.isConnected;
}
