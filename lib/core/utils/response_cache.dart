import 'package:dio/dio.dart';

/// Response cache utility for static/semi-static data
/// Use this for data that doesn't change frequently (configs, static lists, etc.)
class ResponseCache {
  static final Map<String, _CacheEntry> _cache = {};
  
  /// Get cached response if available and fresh
  static Response? getCached(String key, {Duration? maxAge}) {
    final entry = _cache[key];
    if (entry == null) return null;
    
    final age = DateTime.now().difference(entry.timestamp);
    final maxAgeToUse = maxAge ?? const Duration(minutes: 5);
    
    if (age > maxAgeToUse) {
      _cache.remove(key);
      return null;
    }
    
    return entry.response;
  }
  
  /// Cache a response
  static void setCached(String key, Response response) {
    _cache[key] = _CacheEntry(
      response: response,
      timestamp: DateTime.now(),
    );
  }
  
  /// Clear cache for a specific key
  static void clearCache(String key) {
    _cache.remove(key);
  }
  
  /// Clear all cache
  static void clearAllCache() {
    _cache.clear();
  }
  
  /// Get cache size (for debugging)
  static int get cacheSize => _cache.length;
}

class _CacheEntry {
  final Response response;
  final DateTime timestamp;
  
  _CacheEntry({
    required this.response,
    required this.timestamp,
  });
}

/// Cache interceptor for Dio
class CacheInterceptor extends Interceptor {
  final Map<String, Duration> _cacheRules;
  
  CacheInterceptor({
    Map<String, Duration>? cacheRules,
  }) : _cacheRules = cacheRules ?? {};
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Check if this endpoint should be cached
    final cacheKey = _getCacheKey(options);
    final maxAge = _cacheRules[options.path];
    
    if (maxAge != null) {
      final cached = ResponseCache.getCached(cacheKey, maxAge: maxAge);
      if (cached != null) {
        // Return cached response
        handler.resolve(cached);
        return;
      }
    }
    
    handler.next(options);
  }
  
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final cacheKey = _getCacheKey(response.requestOptions);
    final maxAge = _cacheRules[response.requestOptions.path];
    
    if (maxAge != null && response.statusCode == 200) {
      ResponseCache.setCached(cacheKey, response);
    }
    
    handler.next(response);
  }
  
  String _getCacheKey(RequestOptions options) {
    // Include path and query parameters in cache key
    final queryString = options.queryParameters.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');
    return '${options.path}${queryString.isNotEmpty ? '?$queryString' : ''}';
  }
}
