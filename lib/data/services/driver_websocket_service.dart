import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:gauva_driver/data/services/websocket_service.dart';
import '../../domain/interfaces/config_service_interface.dart';

class DriverWebSocketService extends WebSocketService {
  final IConfigService configService;

  DriverWebSocketService({required this.configService});

  String? driverId;
  int? currentRideId;
  StreamSubscription<Position>? _positionSubscription;
  bool _isLocationTrackingActive = false;

  bool _isInitializing = false;

  /// Initialize and connect for driver
  /// Initialize and connect for driver
  Future<void> initializeDriver({required String jwtToken, required int driverId}) async {
    // Prevent multiple initialization attempts
    if (_isInitializing) {
      print('⚠️ Driver WebSocket: Already initializing, skipping...');
      return;
    }

    if (isConnected && this.driverId == driverId.toString()) {
      print('⚠️ Driver WebSocket: Already connected for driver $driverId, skipping...');
      return;
    }

    _isInitializing = true;
    this.driverId = driverId.toString();

    try {
      // Fetch dynamic WebSocket URL
      String? wsUrl;
      // try {
      //   print('🔍 Driver WebSocket: Fetching dynamic WebSocket URL...');
      //   final response = await configService.getWebSocketUrl();
      //   // Assuming response.data is the JSON map as per user prompt:
      //   // final config = jsonDecode(response.body); // Dio returns data directly usually
      //   // final wsUrl = config['websocketUrl'];
      //   // With Dio, response.data is already usually a Map or dynamic
      //
      //   // Handle Dio response data
      //   final data = response.data;
      //   if (data is Map<String, dynamic>) {
      //     wsUrl = data['websocketUrl'];
      //   } else if (data is String) {
      //     // Should not happen with Dio usually if json, but for safety
      //     final decoded = jsonDecode(data);
      //     wsUrl = decoded['websocketUrl'];
      //   }
      //
      //   print('✅ Driver WebSocket: Fetched URL: $wsUrl');
      // } catch (e) {
      //   print('⚠️ Driver WebSocket: Failed to fetch dynamic URL ($e). using default.');
      // }

      // Connect to Raw WebSocket
      await connect(jwtToken, url: wsUrl);

      // Wait for connection with verification
      print('⏳ Driver WebSocket: Waiting for connection to establish...');
      await Future.delayed(const Duration(seconds: 1));

      if (!isConnected) {
        print('⏳ Driver WebSocket: Connection not ready, waiting 2 more seconds...');
        await Future.delayed(const Duration(seconds: 2));
        if (!isConnected) {
          _isInitializing = false;
          throw Exception('Failed to connect to WebSocket after retries');
        }
      }

      print('✅ Driver WebSocket: Connection verified - isConnected: $isConnected');

      // Identify/Join driver room
      print('🚪 Driver WebSocket: Joining driver room (driver:$driverId)...');
      joinRoom('driver', driverId.toString());
      await Future.delayed(const Duration(milliseconds: 500)); // Small delay between joins

      // Join available drivers room to receive requests
      print('🚪 Driver WebSocket: Joining available drivers room (drivers:available) to receive ride requests...');
      joinRoom('drivers', 'available');
      print('✅ Driver WebSocket: Both rooms joined - ready to receive ride requests');
      print('✅ Driver WebSocket: Listening continuously for "new_ride_request" events');

      // Listen for auto-reconnection to re-join
      onReconnected.listen((_) {
        print('🔄 Driver WebSocket: Re-joining rooms after reconnect...');
        if (this.driverId != null) {
          joinRoom('driver', this.driverId!);
          joinRoom('drivers', 'available');
        }
        if (currentRideId != null) {
          print('🔄 Driver WebSocket: Re-joining active ride $currentRideId...');
          joinRoom('ride', currentRideId.toString());
        }
      });

      _isInitializing = false;
      print('✅ Driver WebSocket initialized (Connected: $isConnected)');
    } catch (e) {
      _isInitializing = false;
      print('❌ Driver WebSocket: Error during initialization: $e');
      rethrow;
    }
  }

  /// Helper to join any room
  void joinRoom(String type, String id) {
    print('🚪 Driver WebSocket: Joining room - type: $type, id: $id');
    sendMessage('join', {'type': type, 'id': id});
    print('✅ Driver WebSocket: Join message sent for room $type:$id');
  }

  /// Helper to leave any room
  void leaveRoom(String type, String id) {
    sendMessage('leave', {'type': type, 'id': id});
  }

  /// Join ride room (when ride is accepted)
  void joinRideRoom(int rideId) {
    currentRideId = rideId;
    joinRoom('ride', rideId.toString());
  }

  /// Leave ride room (when ride ends)
  void leaveRideRoom() {
    if (currentRideId != null) {
      leaveRoom('ride', currentRideId.toString());
      stopLocationTracking();
      currentRideId = null;
    }
  }

  /// Start location tracking for active ride
  void startLocationTracking(int rideId) {
    if (_isLocationTrackingActive) {
      return;
    }

    _isLocationTrackingActive = true;
    currentRideId = rideId;

    final locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // meters
    );

    // Use position stream for continuous updates
    _positionSubscription = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (position) {
        // Send via WebSocket (event: location)
        sendMessage('location', {
          'rideId': rideId,
          'driverId': driverId,
          'lat': position.latitude,
          'lng': position.longitude,
          'heading': position.heading,
          // 'speed': position.speed, // Optional based on doc, but good to have if server accepts
        });
      },
      onError: (error) {
        print('Error getting location: $error');
      },
    );
  }

  /// Stop location tracking
  void stopLocationTracking() {
    _isLocationTrackingActive = false;
    _positionSubscription?.cancel();
    _positionSubscription = null;
  }

  /// Update driver online/offline status
  /// Note: The doc mentions 'driver_status' as Server->Client.
  /// For Client->Server to update status, usually it's an HTTP API call or a specific event.
  /// Assuming 'driver_status_update' usage persists or using 'driver' room join implies online.
  /// For now keeping this as is or if there is a specific 'status' event.
  /// The doc doesn't explicitly list a Client->Server status update event,
  /// implying it might be done via HTTP or by joining/leaving 'available' room.
  void updateDriverStatus({required bool isOnline, double? latitude, double? longitude}) {
    // If going online, ensure we are in 'drivers:available'
    if (isOnline) {
      joinRoom('drivers', 'available');
    } else {
      leaveRoom('drivers', 'available');
    }
    // Also sending legacy/explicit message if backend relies on it,
    // but based on room logic, joining 'drivers:available' is key.
    sendMessage('driver_status_update', {'driverId': driverId, 'isOnline': isOnline, 'lat': latitude, 'lng': longitude});
  }

  /// Send chat message to rider
  void sendMessageToRider({
    required int rideId,
    required String message,
    required String senderName,
    required String riderId,
  }) {
    // Send via WebSocket (event: chat)
    sendMessage('chat', {
      'rideId': rideId,
      'senderId': driverId,
      'senderName': senderName,
      'receiverId': riderId,
      'message': message,
    });
  }
}
