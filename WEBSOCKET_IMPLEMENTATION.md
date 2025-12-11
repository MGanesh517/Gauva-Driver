# WebSocket Implementation Guide

This document describes the WebSocket implementation using STOMP protocol for the Driver Flutter App.

## Overview

The app now supports WebSocket communication using STOMP over WebSocket protocol. This replaces or works alongside the existing Pusher service for real-time updates.

## Installation

1. Run `flutter pub get` to install the new dependencies:
   - `stomp_dart_client: ^3.0.1`
   - `web_socket_channel: ^2.4.0`

## Architecture

### Components

1. **WebSocketService** (`lib/data/services/websocket_service.dart`)
   - Manages WebSocket connection lifecycle
   - Handles STOMP protocol communication
   - Manages subscriptions and message sending
   - Automatic reconnection support

2. **WebSocketNotifier** (`lib/presentation/booking/view_model/websocket_notifier.dart`)
   - Handles business logic for WebSocket events
   - Processes ride status updates, chat messages, location updates
   - Integrates with existing Riverpod providers

3. **Message Models** (`lib/data/models/websocket/`)
   - `ride_status_message.dart` - Ride status updates
   - `location_message.dart` - Location updates
   - `driver_status_message.dart` - Driver status updates
   - `chat_message_ws.dart` - Chat messages

## Usage

### Basic Setup

```dart
import 'package:gauva_driver/presentation/booking/provider/websocket_provider.dart';

// In your widget or notifier
final webSocketNotifier = ref.read(webSocketNotifierProvider.notifier);

// Initialize WebSocket connection
await webSocketNotifier.setupWebSocketListeners();
```

### Subscribe to Ride-Specific Topics

```dart
// When a ride starts
final rideId = 123;
await webSocketNotifier.subscribeToRideTopics(rideId);
```

### Send Location Updates

```dart
// Send driver location during active ride
webSocketNotifier.sendLocationUpdate(rideId, latitude, longitude);
```

### Cleanup

```dart
// When ride ends or app closes
await webSocketNotifier.unsubscribeFromRideTopics(rideId);
await webSocketNotifier.disconnect();
```

## Available Topics

### Subscribe Topics

1. **Ride Status Updates**
   - `/topic/ride/{rideId}/status` - Real-time ride status changes

2. **Driver-Specific Rides**
   - `/topic/driver/{driverId}/rides` - All ride updates for a driver

3. **New Ride Requests**
   - `/topic/drivers/ride-requests` - New ride requests for all drivers

4. **Location Updates**
   - `/topic/ride/{rideId}/location` - Driver location during active ride

5. **Chat Messages**
   - `/topic/chat/ride/{rideId}` - Chat messages between driver and rider

6. **Driver Status**
   - `/topic/driver/{driverId}/status` - Driver online/offline status

### Send Messages

1. **Location Update**
   - Destination: `/app/ride/{rideId}/location`
   - Payload: `{ "lat": double, "lng": double, "timestamp": string }`

## Integration Points

### Replace Pusher with WebSocket

To replace Pusher with WebSocket:

1. In your initialization code (e.g., `main.dart` or dashboard):
   ```dart
   // Remove or comment out Pusher initialization
   // await PusherService().init(...);
   
   // Add WebSocket initialization
   final webSocketNotifier = ref.read(webSocketNotifierProvider.notifier);
   await webSocketNotifier.setupWebSocketListeners();
   ```

2. Update event handlers to use WebSocket topics instead of Pusher channels.

### Use Both Services

You can use both Pusher and WebSocket simultaneously if needed. They will work independently.

## Configuration

The WebSocket URL is automatically constructed from `Environment.baseUrl`:
- HTTP: `ws://baseUrl/ws`
- HTTPS: `wss://baseUrl/ws`

The base URL is configured in `lib/core/config/environment.dart` and can be set via `.env` file or environment variables.

## Error Handling

The WebSocket service includes:
- Automatic reconnection (up to 5 attempts)
- Connection state monitoring
- Error callbacks
- Graceful disconnection

## Testing

1. Ensure your backend WebSocket server is running
2. Check that the WebSocket endpoint is accessible
3. Monitor connection state changes
4. Test subscription to topics
5. Verify message sending and receiving

## Troubleshooting

### Connection Issues

1. Verify the WebSocket URL is correct
2. Check network connectivity
3. Ensure backend server supports STOMP over WebSocket
4. Check CORS settings if testing from web

### Message Not Received

1. Verify subscription to correct topic
2. Check topic format matches backend expectations
3. Ensure connection is established before subscribing
4. Check message payload format

### Reconnection Issues

1. Check reconnection delay settings
2. Verify max reconnection attempts
3. Check network stability

## Migration from Pusher

If migrating from Pusher:

1. **Channels to Topics Mapping:**
   - `order.{driverId}` → `/topic/driver/{driverId}/rides`
   - `chat_{driverId}` → `/topic/chat/ride/{rideId}`
   - `order-online.{driverId}` → `/topic/driver/{driverId}/rides` (with payment status)

2. **Event Handling:**
   - Pusher events → WebSocket message callbacks
   - Event data structure may differ, check message models

3. **Initialization:**
   - Replace `PusherService().init()` with `WebSocketNotifier.setupWebSocketListeners()`

## Future Enhancements

- [ ] Add authentication/authorization for WebSocket connections
- [ ] Add message queuing for offline scenarios
- [ ] Add compression for large messages
- [ ] Add metrics and monitoring
- [ ] Add unit tests
