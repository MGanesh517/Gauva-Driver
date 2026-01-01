import 'package:flutter_dotenv/flutter_dotenv.dart';

enum EnvironmentType { dev, prod }

class Environment {
  static const String _devBaseUrl = 'https://gauva-f6f6d9ddagfqc9fw.canadacentral-01.azurewebsites.net';
  static const String _prodBaseUrl = 'https://gauva-f6f6d9ddagfqc9fw.southindia-01.azurewebsites.net';

  static final String _baseUrl = dotenv.env['API_BASE_URL'] ?? _devBaseUrl;
  static final String? _socketIOUrl = dotenv.env['SOCKET_IO_URL'];

  static const EnvironmentType currentEnvironment = EnvironmentType.dev;

  static String? _overrideApiUrl;

  /// Allows runtime override of the API base URL
  static void setApiUrlOverride(String url) {
    _overrideApiUrl = url;
  }

  static String get apiUrl {
    if (_overrideApiUrl != null) return _overrideApiUrl!;
    switch (currentEnvironment) {
      case EnvironmentType.dev:
        return '$_baseUrl/api';
      case EnvironmentType.prod:
        return '$_prodBaseUrl/api';
    }
  }

  static String get baseUrl {
    if (_overrideApiUrl != null) return _overrideApiUrl!;
    switch (currentEnvironment) {
      case EnvironmentType.dev:
        return _baseUrl;
      case EnvironmentType.prod:
        return _prodBaseUrl;
    }
  }

  /// Helper to clean WebSocket URL
  /// Removes ports, fragments, and converts https/http to wss/ws
  static String _cleanWebSocketUrl(String baseUrl, String endpoint) {
    // Step 1: Remove all fragments (#) first
    String wsUrl = baseUrl.split('#').first.trim();

    // Step 2: Convert https to wss, http to ws (Case Insensitive)
    final lowerCased = wsUrl.toLowerCase();
    if (lowerCased.startsWith('https://')) {
      wsUrl = 'wss://${wsUrl.substring(8)}';
    } else if (lowerCased.startsWith('http://')) {
      wsUrl = 'ws://${wsUrl.substring(7)}';
    }

    // Step 3: Remove any port numbers (like :0, :8080, :443)
    wsUrl = wsUrl.replaceAll(RegExp(r':\d+'), '');

    // Step 4: Remove trailing slash if present
    wsUrl = wsUrl.replaceAll(RegExp(r'/$'), '');

    // Step 5: Add endpoint (ensure it starts with /)
    final cleanEndpoint = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    final finalUrl = '$wsUrl$cleanEndpoint';

    // Step 6: Final cleanup - remove any remaining # or fragments
    return finalUrl.split('#').first.trim();
  }

  /// Get Socket.IO URL (defaults to baseUrl if not configured)
  /// ⚠️ WARNING: Socket.IO may not work on Azure (port 9090 not accessible)
  /// Socket.IO runs on a separate port (9090) which is not accessible on Azure App Service
  /// Recommendation: Use STOMP WebSocket as primary method
  static String get socketIOUrl {
    if (_socketIOUrl != null && _socketIOUrl!.isNotEmpty) {
      // Clean the provided URL
      return _cleanWebSocketUrl(_socketIOUrl!, '/socket.io/?EIO=3&transport=websocket');
    }
    // Default Socket.IO URL - use base URL with socket.io path
    // Note: This may not work on Azure if Socket.IO is on port 9090
    return _cleanWebSocketUrl(baseUrl, '/socket.io/?EIO=3&transport=websocket');
  }

  /// Check if Socket.IO is enabled (can be controlled via environment variable)
  /// Default: false (STOMP is primary)
  static bool get socketIOEnabled {
    const String enabled = String.fromEnvironment('SOCKETIO_ENABLED', defaultValue: 'false');
    return enabled.toLowerCase() == 'true';
  }

  /// Get STOMP WebSocket URL
  /// WebSocket Connection URL: wss://gauva-f6f6d9ddagfqc9fw.southindia-01.azurewebsites.net/ws
  static String get stompWebSocketUrl {
    return _cleanWebSocketUrl(baseUrl, '/ws');
  }
}
