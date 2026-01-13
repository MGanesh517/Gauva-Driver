import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:gauva_driver/data/services/local_storage_service.dart';
import '../../../core/routes/app_routes.dart';
import '../navigation_service.dart';

class DioInterceptors extends Interceptor {
  // Cache token in memory to avoid storage read on every request
  static String? _cachedToken;
  static DateTime? _tokenExpirationTime;

  // Track request start times for timing measurement
  final Map<String, DateTime> _requestStartTimes = {};

  // Helper to decode JWT and get expiration
  Map<String, dynamic> _parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      return {};
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      return {};
    }

    return payloadMap;
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Start timing the request
    final requestId = options.uri.toString();
    _requestStartTimes[requestId] = DateTime.now();

    // Get token from cache or storage
    if (_cachedToken == null || _tokenExpirationTime == null || DateTime.now().isAfter(_tokenExpirationTime!)) {
      final token = await LocalStorageService().getToken();

      if (token != null) {
        _cachedToken = token;
        try {
          final payload = _parseJwt(token);
          if (payload.containsKey('exp')) {
            // exp is in seconds
            final exp = payload['exp'] as int;
            _tokenExpirationTime = DateTime.fromMillisecondsSinceEpoch(exp * 1000);

            // Log expiration for debugging
            if (kDebugMode) {
              print('🔐 Token cached. Expires at: $_tokenExpirationTime');
            }
          } else {
            // Fallback if no exp claim: 30 minutes
            _tokenExpirationTime = DateTime.now().add(const Duration(minutes: 30));
          }
        } catch (e) {
          if (kDebugMode) {
            print('⚠️ Failed to parse JWT token: $e');
          }
          // Fallback on error: 30 minutes
          _tokenExpirationTime = DateTime.now().add(const Duration(minutes: 30));
        }
      }
    }

    if (_cachedToken != null) {
      options.headers['Authorization'] = 'Bearer $_cachedToken';
    }

    // Log request start (only in debug mode)
    if (kDebugMode) {
      print('🚀 API Request: ${options.method} ${options.uri}');
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final requestId = response.requestOptions.uri.toString();
    final startTime = _requestStartTimes.remove(requestId);

    if (startTime != null) {
      final duration = DateTime.now().difference(startTime);
      final durationMs = duration.inMilliseconds;

      // Log response time (always log for performance monitoring)
      print(
        '⏱️ API Response Time: ${durationMs}ms | ${response.requestOptions.method} ${response.requestOptions.uri.path}',
      );

      // Warn if response is slow
      if (durationMs > 2000) {
        print('⚠️ SLOW API: ${response.requestOptions.uri.path} took ${durationMs}ms (>2s)');
      } else if (durationMs > 1000) {
        print('🐌 API took ${durationMs}ms (>1s) - Consider optimization');
      }
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final requestId = err.requestOptions.uri.toString();
    final startTime = _requestStartTimes.remove(requestId);

    if (startTime != null) {
      final duration = DateTime.now().difference(startTime);
      final durationMs = duration.inMilliseconds;
      print(
        '❌ API Error after ${durationMs}ms: ${err.requestOptions.method} ${err.requestOptions.uri.path} | ${err.type}',
      );
    }

    final navigatorKey = NavigationService.navigatorKey;
    final currentContext = navigatorKey.currentContext;
    final currentRoute = currentContext != null ? ModalRoute.of(currentContext)?.settings.name : null;

    if (err.response?.statusCode == 401) {
      // Clear cached token on 401
      clearTokenCache();

      await LocalStorageService().clearToken();
      await LocalStorageService().clearStorage();

      if (currentContext != null && currentRoute != AppRoutes.login) {
        NavigationService.pushNamedAndRemoveUntil(AppRoutes.login);
      }
    }

    return super.onError(err, handler);
  }

  // Method to clear token cache (call after logout or token update)
  static void clearTokenCache() {
    _cachedToken = null;
    _tokenExpirationTime = null;
  }
}
