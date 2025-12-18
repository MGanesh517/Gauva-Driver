import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/io.dart';
import '../../core/config/environment.dart';

/// Base WebSocket service for Plain WebSocket (Raw JSON)
class WebSocketService {
  // WebSocket channel
  IOWebSocketChannel? _channel;

  // Connection status
  bool isConnected = false;

  // Stream controllers for events
  final _rideStatusController = StreamController<Map<String, dynamic>>.broadcast();
  final _driverLocationController = StreamController<Map<String, dynamic>>.broadcast();
  final _walletUpdateController = StreamController<Map<String, dynamic>>.broadcast();
  final _chatMessageController = StreamController<Map<String, dynamic>>.broadcast();
  final _driverStatusController = StreamController<Map<String, dynamic>>.broadcast();
  final _newRideRequestController = StreamController<Map<String, dynamic>>.broadcast();
  final _fleetStatsController = StreamController<Map<String, dynamic>>.broadcast();

  // Protected methods to add to streams (for subclasses)
  void addToRideStatusStream(Map<String, dynamic> data) => _rideStatusController.add(data);
  void addToDriverLocationStream(Map<String, dynamic> data) => _driverLocationController.add(data);
  void addToWalletUpdateStream(Map<String, dynamic> data) => _walletUpdateController.add(data);
  void addToChatMessageStream(Map<String, dynamic> data) => _chatMessageController.add(data);
  void addToDriverStatusStream(Map<String, dynamic> data) => _driverStatusController.add(data);
  void addToNewRideRequestStream(Map<String, dynamic> data) => _newRideRequestController.add(data);
  void addToFleetStatsStream(Map<String, dynamic> data) => _fleetStatsController.add(data);

  // Auto-reconnect support
  bool _shouldReconnect = true;
  String? _jwtToken;
  Timer? _reconnectTimer;
  Timer? _healthCheckTimer;
  final _onReconnectedController = StreamController<void>.broadcast();

  // Getters for streams
  Stream<Map<String, dynamic>> get rideStatusStream => _rideStatusController.stream;
  Stream<Map<String, dynamic>> get driverLocationStream => _driverLocationController.stream;
  Stream<Map<String, dynamic>> get walletUpdateStream => _walletUpdateController.stream;
  Stream<Map<String, dynamic>> get chatMessageStream => _chatMessageController.stream;
  Stream<Map<String, dynamic>> get driverStatusStream => _driverStatusController.stream;
  Stream<Map<String, dynamic>> get newRideRequestStream {
    print('🔍 WebSocket: Accessing newRideRequestStream getter');
    return _newRideRequestController.stream;
  }
  Stream<Map<String, dynamic>> get fleetStatsStream => _fleetStatsController.stream;
  Stream<void> get onReconnected => _onReconnectedController.stream;

  /// Connect to Raw All-in-One WebSocket
  Future<void> connect(String jwtToken) async {
    // Store token for auto-reconnect
    _jwtToken = jwtToken;
    _shouldReconnect = true;

    // Prevent multiple connection attempts
    if (isConnected && _channel != null) {
      print('⚠️ WebSocket Service: Already connected, skipping...');
      return;
    }

    // Don't call disconnect() here as it sets _shouldReconnect to false
    // Just close existing channel if any
    if (_channel != null) {
      try {
        _channel!.sink.close();
      } catch (e) {
        /* ignore */
      }
      _channel = null;
    }

    try {
      final wsUrl = Environment.stompWebSocketUrl;

      print('🔌 WebSocket Service: Connecting to Raw WebSocket at $wsUrl');
      print('🔑 WebSocket Service: Using token (length: ${jwtToken.length})');

      _channel = IOWebSocketChannel.connect(
        Uri.parse(wsUrl),
        headers: {'Authorization': 'Bearer $jwtToken'},
        pingInterval: const Duration(seconds: 10),
      );

      isConnected = true;
      print('✅ WebSocket Connection initiated');
      print('✅ WebSocket: Connection established - ready to receive messages');
      print('✅ WebSocket: Stream listener will be attached for continuous listening');

      // Listen to incoming messages
      _channel!.stream.listen(
        (message) {
          _handleIncomingMessage(message);
        },
        onDone: () {
          print('❌ WebSocket Closed - Connection terminated');
          isConnected = false;
          _attemptReconnect();
        },
        onError: (error) {
          print('❌ WebSocket Error: $error');
          isConnected = false;
          _attemptReconnect();
        },
        cancelOnError: false, // Keep listening even on errors
      );
      
      print('✅ WebSocket: Stream listener attached - continuously listening for messages');
      
      // Start health check timer (every 30 seconds)
      _healthCheckTimer?.cancel();
      _healthCheckTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
        if (isConnected && _channel != null) {
          print('💓 WebSocket: Health check - Connection active, listening continuously');
          // Optionally send ping to keep connection alive
          try {
            sendMessage('ping', {});
          } catch (e) {
            print('⚠️ WebSocket: Error sending ping: $e');
          }
        } else {
          print('⚠️ WebSocket: Health check - Connection lost, attempting reconnect...');
          _attemptReconnect();
        }
      });
    } catch (e) {
      print('❌ Error connecting to WebSocket: $e');
      isConnected = false;
      // If initial connection fails, attempt reconnect
      _attemptReconnect();
      rethrow;
    }
  }

  /// Attempt to reconnect after a delay
  void _attemptReconnect() {
    if (!_shouldReconnect || _jwtToken == null) {
      return;
    }

    if (_reconnectTimer != null && _reconnectTimer!.isActive) {
      return; // Already scheduled
    }

    print('⏳ WebSocket: Scheduling reconnect in 5s...');
    _reconnectTimer = Timer(const Duration(seconds: 5), () async {
      if (!_shouldReconnect || isConnected) return;

      print('🔄 WebSocket: Attempting to reconnect...');
      try {
        await connect(_jwtToken!);
        // connect() rethrows on error, so we catch it here to loop again
        if (isConnected) {
          print('✅ WebSocket: Auto-reconnected successfully');
          _onReconnectedController.add(null);
        }
      } catch (e) {
        print('❌ WebSocket: Auto-reconnect failed ($e). Retrying in 5s...');
        _attemptReconnect();
      }
    });
  }

  /// Handle incoming raw JSON message
  void _handleIncomingMessage(dynamic message) {
    try {
      print('📩 WebSocket Received (raw): $message'); // Enable logging to verify continuous listening
      final decoded = jsonDecode(message);

      if (decoded is Map<String, dynamic>) {
        final event = decoded['event'];
        final data = decoded['data'];
        
        // Enhanced logging for new_ride_request events
        if (event == 'new_ride_request') {
          print('🔍 WebSocket: Detected new_ride_request event in raw message!');
          print('🔍 WebSocket: Event: $event');
          print('🔍 WebSocket: Data type: ${data.runtimeType}');
          print('🔍 WebSocket: Message keys: ${decoded.keys.toList()}');
        }

        // Handle "connected" event/confirmation
        if (event == 'connected') {
          print('✅ WebSocket Server Confirmation: ${data['message'] ?? 'Connected'}');
          print('✅ WebSocket: Connection established and listening continuously');
          return;
        }
        
        // Handle "joined" event/confirmation
        if (event == 'joined') {
          final room = data?['room'] ?? 
                      data?['type'] ?? 
                      (decoded['room'] ?? decoded['type']);
          print('✅ WebSocket: Successfully joined room: $room');
          if (data != null && data is Map) {
            print('✅ WebSocket: Join confirmation data: $data');
          }
          return;
        }
        
        // Handle "pong" event (response to ping)
        if (event == 'pong') {
          print('💓 WebSocket: Pong received - connection is alive');
          return;
        }

        // Dispatch based on 'event' name
        if (event != null && data != null) {
          // Normalize data to Map<String, dynamic>
          final Map<String, dynamic> mapData = data is Map<String, dynamic> ? data : {'payload': data};

          switch (event) {
            case 'ride_status':
            case 'rideStatus':
              print('📱 Ride Status Update: $mapData');
              _rideStatusController.add(mapData);
              break;
            case 'driver_location':
            case 'driverLocation':
              print('📍 Driver Location: $mapData');
              _driverLocationController.add(mapData);
              break;
            case 'wallet_update':
            case 'walletUpdate':
              print('💰 Wallet Update: $mapData');
              _walletUpdateController.add(mapData);
              break;
            case 'chat_message':
            case 'chatMessage':
              print('💬 Chat Message: $mapData');
              _chatMessageController.add(mapData);
              break;
            case 'driver_status':
            case 'driverStatus':
              print('🚗 Driver Status: $mapData');
              _driverStatusController.add(mapData);
              break;
            case 'new_ride_request':
            case 'newRideRequest':
              print('🆕 ==========================================');
              print('🆕 NEW RIDE REQUEST EVENT RECEIVED!');
              print('🆕 Event: $event');
              print('🆕 Full Data Object: $mapData');
              print('🆕 Data Type: ${mapData.runtimeType}');
              print('🆕 Data Keys: ${mapData.keys.toList()}');
              print('🆕 Attempting to extract Ride ID...');
              
              // Try multiple possible ID fields
              final rideId = mapData['rideId'] ?? 
                            mapData['id'] ?? 
                            mapData['orderId'] ??
                            mapData['order_id'] ??
                            mapData['ride']?['id'] ??
                            mapData['ride']?['rideId'] ??
                            mapData['order']?['id'] ??
                            mapData['order']?['orderId'];
              
              print('🆕 Extracted Ride ID: $rideId (type: ${rideId?.runtimeType})');
              print('🆕 Adding to newRideRequestStream...');
              
              _newRideRequestController.add(mapData);
              
              print('🆕 ✅ Successfully added to newRideRequestStream');
              print('🆕 ✅ Any active listeners will receive this event');
              print('🆕 ==========================================');
              break;
            case 'fleet_stats':
              print('📊 Fleet Stats: $mapData');
              _fleetStatsController.add(mapData);
              break;
            default:
              print('⚠️ Unhandled WebSocket Event: $event');
          }
        }
      }
    } catch (e) {
      print('❌ Error parsing WebSocket message: $e\nMessage: $message');
    }
  }

  /// Send message via WebSocket
  /// Format: {"event": "eventName", "data": {...}}
  /// Special handling for "join" and "leave" events where type/id are at root level
  void sendMessage(String eventName, Map<String, dynamic> data) {
    if (!isConnected || _channel == null) {
      print('⚠️ WebSocket not connected. Cannot send $eventName.');
      return;
    }

    try {
      Map<String, dynamic> payload;
      
      // Special handling for join/leave events - type and id should be at root level
      if (eventName == 'join' || eventName == 'leave') {
        payload = {
          'event': eventName,
          'type': data['type'],
          'id': data['id'],
        };
      } else {
        // For all other events, use standard format with data object
        payload = {'event': eventName, 'data': data};
      }
      
      final message = jsonEncode(payload);
      print('📤 WebSocket Sending: $message');
      _channel!.sink.add(message);
      print('✅ WebSocket: Message sent successfully');
    } catch (e) {
      print('❌ Error sending WebSocket message: $e');
    }
  }

  /// Disconnect
  void disconnect() {
    _shouldReconnect = false;
    _reconnectTimer?.cancel();
    _healthCheckTimer?.cancel();

    if (_channel != null) {
      try {
        _channel!.sink.close();
      } catch (e) {
        print('Error closing sink: $e');
      }
      _channel = null;
    }
    isConnected = false;
    print('🔌 WebSocket: Disconnected and cleanup complete');
  }
}
