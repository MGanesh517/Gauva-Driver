import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gauva_driver/data/services/driver_websocket_service.dart';
import 'package:gauva_driver/data/services/local_storage_service.dart';

class WebSocketNotifier extends StateNotifier<void> {
  final Ref ref;
  final DriverWebSocketService _driverWebSocketService = DriverWebSocketService();

  WebSocketNotifier(this.ref) : super(null);

  /// Setup WebSocket and subscribe to necessary topics
  Future<void> setupWebSocketListeners() async {
    try {
      print('🔌 WebSocket Notifier: Setting up WebSocket listeners...');

      // Get driver ID
      int? driverId = await LocalStorageService().getUserId();
      if (driverId == null) {
        print('❌ WebSocket Notifier: No driver ID found');
        return;
      }

      // Get JWT token (same as splash screen)
      final token = await LocalStorageService().getToken();
      if (token == null || token.isEmpty) {
        print('❌ WebSocket Notifier: No token found');
        return;
      }

      print('🔌 WebSocket Notifier: Driver ID: $driverId');

      // Initialize driver WebSocket service
      await _driverWebSocketService.initializeDriver(jwtToken: token, driverId: driverId);

      print('✅ WebSocket Notifier: Driver WebSocket service initialized');
    } catch (e, stackTrace) {
      print('❌ WebSocket Notifier: Error setting up listeners: $e');
      print('❌ WebSocket Notifier: Stack trace: $stackTrace');
    }
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
  void sendLocationUpdate(int rideId, double lat, double lng, {double? heading}) {
    _driverWebSocketService.sendLocationUpdate(
      rideId: rideId,
      driverId: int.tryParse(_driverWebSocketService.driverId ?? '0'),
      lat: lat,
      lng: lng,
      heading: heading,
    );
  }

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

  bool get isConnected => _driverWebSocketService.isStompConnected || _driverWebSocketService.isSocketIOConnected;
}
