import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:gauva_driver/data/services/websocket_service.dart';

class DriverWebSocketService extends WebSocketService {
  String? driverId;
  int? currentRideId;
  StreamSubscription<Position>? _positionSubscription;
  bool _isLocationTrackingActive = false;

  /// Initialize and connect for driver
  Future<void> initializeDriver({required String jwtToken, required int driverId}) async {
    this.driverId = driverId.toString();

    // PRIMARY: Connect to STOMP (works on Azure)
    await connectStomp(jwtToken);

    // OPTIONAL: Try Socket.IO (may not work on Azure - that's OK)
    connectSocketIO(jwtToken).catchError((error) {
      print('⚠️ Socket.IO connection failed (expected on Azure): $error');
      print('✅ Continuing with STOMP only');
    });

    // Wait for STOMP connection
    await Future.delayed(const Duration(seconds: 2));

    if (!isStompConnected) {
      throw Exception('Failed to connect to STOMP WebSocket');
    }

    // Join driver room and available drivers room via Socket.IO (if available)
    if (isSocketIOConnected) {
      joinRoom('driver', driverId);
      joinRoom('drivers', null); // Available drivers room
    }

    print('✅ Driver WebSocket initialized (STOMP: $isStompConnected, Socket.IO: $isSocketIOConnected)');
  }

  /// Join ride room (when ride is accepted)
  void joinRideRoom(int rideId) {
    currentRideId = rideId;

    // Join via Socket.IO (for ride_status, driver_location, chat_message)
    joinRoom('ride', rideId);

    // Also join driver room for ride_status and wallet_update
    if (driverId != null) {
      joinRoom('driver', int.tryParse(driverId!));
    }

    // Subscribe to STOMP topics for this ride
    // STOMP is used for location tracking and chat
    subscribeToStompTopic(
      '/topic/ride/$rideId/location', // Actual backend topic
      (data) {
        print('📍 STOMP Driver Location: $data');
        addToDriverLocationStream(data);
      },
    );

    subscribeToStompTopic(
      '/topic/chat/ride/$rideId', // Actual backend topic
      (data) {
        print('💬 STOMP Chat Message: $data');
        addToChatMessageStream(data);
      },
    );
  }

  /// Leave ride room (when ride ends)
  void leaveRideRoom() {
    if (currentRideId != null) {
      leaveRoom('ride', currentRideId);
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
      distanceFilter: 5, // meters
    );

    // Use position stream for continuous updates
    _positionSubscription = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (position) {
        // Send location via Socket.IO
        sendLocationUpdate(
          rideId: rideId,
          driverId: int.tryParse(driverId ?? '0'),
          lat: position.latitude,
          lng: position.longitude,
          heading: position.heading,
        );

        // Also send via STOMP (actual backend endpoint)
        sendStompMessage(
          '/app/ride/$rideId/location', // Actual backend MessageMapping
          {
            'lat': position.latitude,
            'lng': position.longitude,
            'heading': position.heading,
            'speed': position.speed,
            'ts': DateTime.now().millisecondsSinceEpoch ~/ 1000,
          },
        );
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
  void updateDriverStatus({required bool isOnline, double? latitude, double? longitude}) {
    // This would typically call your REST API
    // But you can also emit via Socket.IO if server supports it
    if (isSocketIOConnected) {
      socketIO!.emit('driver_status', {
        'driverId': driverId,
        'isOnline': isOnline,
        'latitude': latitude,
        'longitude': longitude,
      });
    }
  }

  /// Send chat message to rider
  void sendMessageToRider({
    required int rideId,
    required String message,
    required String senderName,
    required String riderId,
  }) {
    final messageId = DateTime.now().millisecondsSinceEpoch.toString();

    // Send via Socket.IO
    sendChatMessage(
      rideId: rideId,
      senderId: driverId!,
      senderName: senderName,
      receiverId: riderId,
      message: message,
      messageId: messageId,
    );

    // Also send via STOMP
    sendStompMessage(
      '/app/chat/send', // Actual backend endpoint
      {
        'rideId': rideId,
        'senderId': driverId,
        'senderName': senderName,
        'receiverId': riderId,
        'message': message,
        'messageId': messageId,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }
}
