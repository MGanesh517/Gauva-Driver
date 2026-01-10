import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:gauva_driver/data/services/local_storage_service.dart';
import '../../../core/routes/app_routes.dart';
import '../navigation_service.dart';

class DioInterceptors extends Interceptor {
  // Cache token in memory to avoid storage read on every request
  static String? _cachedToken;
  static DateTime? _tokenCacheTime;
  static const _tokenCacheExpiry = Duration(minutes: 30);

  // Track request start times for timing measurement
  final Map<String, DateTime> _requestStartTimes = {};

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Start timing the request
    final requestId = options.uri.toString();
    _requestStartTimes[requestId] = DateTime.now();

    // Get token from cache or storage
    if (_cachedToken == null || 
        _tokenCacheTime == null || 
        DateTime.now().difference(_tokenCacheTime!) > _tokenCacheExpiry) {
      _cachedToken = await LocalStorageService().getToken();
      _tokenCacheTime = DateTime.now();
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
      print('⏱️ API Response Time: ${durationMs}ms | ${response.requestOptions.method} ${response.requestOptions.uri.path}');
      
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
      print('❌ API Error after ${durationMs}ms: ${err.requestOptions.method} ${err.requestOptions.uri.path} | ${err.type}');
    }

    final navigatorKey = NavigationService.navigatorKey;
    final currentContext = navigatorKey.currentContext;
    final currentRoute = currentContext != null ? ModalRoute.of(currentContext)?.settings.name : null;

    if (err.response?.statusCode == 401) {
      // Clear cached token on 401
      _cachedToken = null;
      _tokenCacheTime = null;
      
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
    _tokenCacheTime = null;
  }
}
