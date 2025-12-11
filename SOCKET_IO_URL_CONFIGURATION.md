# Socket.IO URL Configuration

## ✅ Configuration Updated

The WebSocket connection has been configured to use Socket.IO with the following URL:

**Socket.IO URL:** `wss://gauva-b7gaf7bwcwhqa0c6.canadacentral-01.azurewebsites.net`

The Socket.IO client will automatically append the path: `/socket.io/?EIO=3&transport=websocket`

## Changes Made

### 1. Environment Configuration
- Updated `Environment.socketIOUrl` to use the specified Socket.IO URL
- Default URL is now: `wss://gauva-b7gaf7bwcwhqa0c6.canadacentral-01.azurewebsites.net`

### 2. Default Protocol
- Changed default from STOMP to **Socket.IO**
- App will now use Socket.IO by default when driver goes online

### 3. Socket.IO Service
- Enhanced logging to show the full URL being used
- Socket.IO client automatically handles the path and query parameters

## Connection Flow

When driver goes online, the app will:

1. **Connect to Socket.IO server:**
   ```
   🔌 Socket.IO: Base URL: wss://gauva-b7gaf7bwcwhqa0c6.canadacentral-01.azurewebsites.net
   🔌 Socket.IO: Full URL will be: wss://gauva-b7gaf7bwcwhqa0c6.canadacentral-01.azurewebsites.net/socket.io/?EIO=3&transport=websocket
   ```

2. **Join rooms:**
   - Driver room: `driver:{driverId}`
   - Available drivers room: `drivers`

3. **Listen to events:**
   - `ride_status` - Ride status updates
   - `driver_location` - Driver location updates
   - `new_ride_request` - New ride requests
   - `driver_status` - Driver status updates
   - `wallet_update` - Wallet updates
   - `chat_message` - Chat messages

## Expected Logs

### On Connection:
```
🟢 Driver: Going ONLINE - Starting WebSocket connection...
🔌 WebSocket Notifier: Setting up WebSocket listeners...
🔌 WebSocket Notifier: Driver ID: 123
🔌 WebSocket Notifier: Using Socket.IO
🔌 Socket.IO: Base URL: wss://gauva-b7gaf7bwcwhqa0c6.canadacentral-01.azurewebsites.net
🔌 Socket.IO: Full URL will be: wss://gauva-b7gaf7bwcwhqa0c6.canadacentral-01.azurewebsites.net/socket.io/?EIO=3&transport=websocket
🔌 Socket.IO: Token available: true
🔌 Socket.IO: Connection initiated
✅ Socket.IO: Connected successfully!
📡 Socket.IO: Joining driver room...
✅ Socket.IO: Joined room: driver:123
📡 Socket.IO: Joining drivers room...
✅ Socket.IO: Joined room: drivers
✅ Socket.IO: All rooms joined
```

## Testing

1. **Run the app**
2. **Toggle driver to ONLINE**
3. **Check logs** for:
   - Connection to the Socket.IO URL
   - Successful connection message
   - Rooms joined successfully
   - Events being received

## Customization

If you need to change the Socket.IO URL, you can:

1. **Set in `.env` file:**
   ```env
   SOCKET_IO_URL=wss://your-custom-url.com
   ```

2. **Or modify `Environment.socketIOUrl`** in `lib/core/config/environment.dart`

## Protocol Details

- **Protocol:** Socket.IO v3 (EIO=3)
- **Transport:** WebSocket (with polling fallback)
- **URL Format:** `wss://domain/socket.io/?EIO=3&transport=websocket`
- **Authentication:** Bearer token in headers (if token available)

The Socket.IO client library handles all the protocol details automatically!
