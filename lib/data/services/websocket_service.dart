import 'dart:async';
import 'dart:convert';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:gauva_driver/data/services/local_storage_service.dart';

/// Base WebSocket service for both STOMP and Socket.IO
class WebSocketService {
  // Configuration
  static const String baseUrl = 'https://gauva-f6f6d9ddagfqc9fw.canadacentral-01.azurewebsites.net';
  static const String socketIOUrl = 'https://gauva-f6f6d9ddagfqc9fw.canadacentral-01.azurewebsites.net';

  // STOMP client
  StompClient? stompClient;

  // Socket.IO client
  IO.Socket? socketIO;

  // Connection status
  bool isStompConnected = false;
  bool isSocketIOConnected = false;

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

  // Getters for streams
  Stream<Map<String, dynamic>> get rideStatusStream => _rideStatusController.stream;
  Stream<Map<String, dynamic>> get driverLocationStream => _driverLocationController.stream;
  Stream<Map<String, dynamic>> get walletUpdateStream => _walletUpdateController.stream;
  Stream<Map<String, dynamic>> get chatMessageStream => _chatMessageController.stream;
  Stream<Map<String, dynamic>> get driverStatusStream => _driverStatusController.stream;
  Stream<Map<String, dynamic>> get newRideRequestStream => _newRideRequestController.stream;
  Stream<Map<String, dynamic>> get fleetStatsStream => _fleetStatsController.stream;

  /// Connect to STOMP WebSocket
  Future<void> connectStomp(String jwtToken) async {
    try {
      // Use wss:// for HTTPS connections (production)
      final wsUrl = baseUrl.startsWith('https')
          ? baseUrl.replaceFirst('https', 'wss')
          : baseUrl.replaceFirst('http', 'ws');

      final stompConfig = StompConfig(
        url: '$wsUrl/ws',
        onConnect: (frame) {
          print('✅ STOMP Connected');
          isStompConnected = true;
        },
        onStompError: (frame) {
          print('❌ STOMP Error: ${frame.body}');
          isStompConnected = false;
        },
        onWebSocketError: (error) {
          print('❌ WebSocket Error: $error');
          isStompConnected = false;
        },
        onDisconnect: (frame) {
          print('❌ STOMP Disconnected');
          isStompConnected = false;
        },
        stompConnectHeaders: {'Authorization': 'Bearer $jwtToken'},
        webSocketConnectHeaders: {'Authorization': 'Bearer $jwtToken'},
        beforeConnect: () async {
          await Future.delayed(const Duration(milliseconds: 300));
        },
        heartbeatIncoming: const Duration(milliseconds: 4000),
        heartbeatOutgoing: const Duration(milliseconds: 4000),
      );

      stompClient = StompClient(config: stompConfig);
      stompClient!.activate();
    } catch (e) {
      print('Error connecting to STOMP: $e');
      rethrow;
    }
  }

  /// Connect to Socket.IO
  /// NOTE: Socket.IO may not be available on Azure App Service
  /// Use STOMP WebSocket instead for production
  Future<void> connectSocketIO(String? jwtToken) async {
    try {
      // Convert https to wss for WebSocket
      final wsUrl = socketIOUrl.startsWith('https')
          ? socketIOUrl.replaceFirst('https://', 'wss://')
          : socketIOUrl.replaceFirst('http://', 'ws://');

      // Remove port if it's the default (Socket.IO may run on same port as main server)
      final cleanUrl = wsUrl.replaceAll(':9090', '').replaceAll(':0', '');

      print('🔌 Connecting Socket.IO to: $cleanUrl');

      socketIO = IO.io(
        cleanUrl,
        IO.OptionBuilder()
            .setTransports(['websocket', 'polling'])
            .setQuery({'EIO': '3'}) // Use EIO=3 for Socket.IO v1.x
            .enableAutoConnect()
            .enableReconnection()
            .setReconnectionDelay(1000)
            .setReconnectionDelayMax(5000)
            .setReconnectionAttempts(999999) // Keep trying
            .setTimeout(20000)
            .build(),
      );

      // Connection events
      socketIO!.onConnect((_) {
        print('✅ Socket.IO Connected');
        isSocketIOConnected = true;
      });

      socketIO!.onDisconnect((_) {
        print('❌ Socket.IO Disconnected');
        isSocketIOConnected = false;
      });

      socketIO!.onConnectError((error) {
        print('❌ Socket.IO Connection Error: $error');
        isSocketIOConnected = false;
      });

      // Server confirmation
      socketIO!.on('connected', (data) {
        print('Server confirmation: $data');
      });

      // Error handling
      socketIO!.on('error', (data) {
        print('Socket.IO Error: $data');
      });

      // Join error
      socketIO!.on('join_error', (data) {
        print('Join Error: $data');
      });

      // Real-time event listeners
      _setupSocketIOListeners();
    } catch (e) {
      print('Error connecting to Socket.IO: $e');
      rethrow;
    }
  }

  /// Setup Socket.IO event listeners
  void _setupSocketIOListeners() {
    // Ride status updates
    socketIO!.on('ride_status', (data) {
      print('📱 Ride Status Update: $data');
      _rideStatusController.add(Map<String, dynamic>.from(data));
    });

    // Driver location updates
    socketIO!.on('driver_location', (data) {
      print('📍 Driver Location: $data');
      _driverLocationController.add(Map<String, dynamic>.from(data));
    });

    // Wallet updates
    socketIO!.on('wallet_update', (data) {
      print('💰 Wallet Update: $data');
      _walletUpdateController.add(Map<String, dynamic>.from(data));
    });

    // Chat messages
    socketIO!.on('chat_message', (data) {
      print('💬 Chat Message: $data');
      _chatMessageController.add(Map<String, dynamic>.from(data));
    });

    // Driver status updates
    socketIO!.on('driver_status', (data) {
      print('🚗 Driver Status: $data');
      _driverStatusController.add(Map<String, dynamic>.from(data));
    });

    // New ride request (for drivers)
    socketIO!.on('new_ride_request', (data) {
      print('🆕 New Ride Request: $data');
      _newRideRequestController.add(Map<String, dynamic>.from(data));
    });

    // Fleet stats (for admin)
    socketIO!.on('fleet_stats', (data) {
      print('📊 Fleet Stats: $data');
      _fleetStatsController.add(Map<String, dynamic>.from(data));
    });
  }

  /// Join a room (Socket.IO)
  void joinRoom(String type, dynamic id) {
    if (!isSocketIOConnected) {
      print('⚠️ Socket.IO not connected. Cannot join room.');
      return;
    }

    socketIO!.emit('join', {'type': type, 'id': id});

    socketIO!.on('joined', (data) {
      print('✅ Joined room: $data');
    });
  }

  /// Leave a room (Socket.IO)
  void leaveRoom(String type, dynamic id) {
    if (!isSocketIOConnected) {
      return;
    }

    socketIO!.emit('leave', {'type': type, 'id': id});
  }

  /// Send location update (Socket.IO)
  void sendLocationUpdate({
    required int rideId,
    required int? driverId,
    required double lat,
    required double lng,
    double? heading,
  }) {
    if (!isSocketIOConnected) {
      print('⚠️ Socket.IO not connected. Cannot send location.');
      return;
    }

    socketIO!.emit('location', {'rideId': rideId, 'driverId': driverId, 'lat': lat, 'lng': lng, 'heading': heading});
  }

  /// Send chat message (Socket.IO)
  void sendChatMessage({
    required int rideId,
    required String senderId,
    required String senderName,
    required String receiverId,
    required String message,
    required String messageId,
  }) {
    if (!isSocketIOConnected) {
      print('⚠️ Socket.IO not connected. Cannot send chat.');
      return;
    }

    socketIO!.emit('chat', {
      'rideId': rideId,
      'senderId': senderId,
      'senderName': senderName,
      'receiverId': receiverId,
      'message': message,
      'messageId': messageId,
    });
  }

  /// Subscribe to STOMP topic
  void subscribeToStompTopic(String topic, Function(Map<String, dynamic>) callback) {
    if (!isStompConnected || stompClient == null) {
      print('⚠️ STOMP not connected. Cannot subscribe.');
      return;
    }

    stompClient!.subscribe(
      destination: topic,
      callback: (frame) {
        try {
          final data = jsonDecode(frame.body!) as Map<String, dynamic>;
          callback(data);
        } catch (e) {
          print('Error parsing STOMP message: $e');
        }
      },
    );
  }

  /// Send message via STOMP
  void sendStompMessage(String destination, Map<String, dynamic> message) {
    if (!isStompConnected || stompClient == null) {
      print('⚠️ STOMP not connected. Cannot send message.');
      return;
    }

    stompClient!.send(destination: destination, body: jsonEncode(message));
  }

  /// Disconnect all
  void disconnect() {
    if (stompClient != null) {
      stompClient!.deactivate();
      stompClient = null;
      isStompConnected = false;
    }

    if (socketIO != null) {
      socketIO!.disconnect();
      socketIO!.dispose();
      socketIO = null;
      isSocketIOConnected = false;
    }

    // Close stream controllers
    _rideStatusController.close();
    _driverLocationController.close();
    _walletUpdateController.close();
    _chatMessageController.close();
    _driverStatusController.close();
    _newRideRequestController.close();
    _fleetStatsController.close();
  }
}
