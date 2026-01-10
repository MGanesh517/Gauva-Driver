import 'dart:async';

/// Utility class to measure API response time from Flutter side
/// This helps identify if slowness is in Flutter, network, or backend
class ApiTimingUtil {
  /// Measure the time taken by an async API call
  /// 
  /// Usage:
  /// ```dart
  /// final result = await ApiTimingUtil.measure(
  ///   name: 'Get Dashboard',
  ///   apiCall: () => dio.get('/dashboard'),
  /// );
  /// ```
  /// 
  /// Output: "⏱️ [Get Dashboard] took 1234ms"
  static Future<T> measure<T>({
    required String name,
    required Future<T> Function() apiCall,
    bool logSlowRequests = true,
    int slowThresholdMs = 1000,
  }) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      final result = await apiCall();
      stopwatch.stop();
      
      final durationMs = stopwatch.elapsedMilliseconds;
      
      // Always log for debugging
      print('⏱️ [Flutter] [$name] took ${durationMs}ms');
      
      // Warn if slow
      if (logSlowRequests && durationMs > slowThresholdMs) {
        if (durationMs > 2000) {
          print('⚠️ [Flutter] SLOW: [$name] took ${durationMs}ms (>2s)');
        } else {
          print('🐌 [Flutter] [$name] took ${durationMs}ms (>1s)');
        }
      }
      
      return result;
    } catch (e) {
      stopwatch.stop();
      final durationMs = stopwatch.elapsedMilliseconds;
      print('❌ [Flutter] [$name] failed after ${durationMs}ms: $e');
      rethrow;
    }
  }

  /// Measure time with custom callback for additional actions
  /// 
  /// Usage:
  /// ```dart
  /// final result = await ApiTimingUtil.measureWithCallback(
  ///   name: 'Get Dashboard',
  ///   apiCall: () => dio.get('/dashboard'),
  ///   onComplete: (duration) {
  ///     // Send to analytics
  ///     analytics.logEvent('api_timing', {'duration': duration});
  ///   },
  /// );
  /// ```
  static Future<T> measureWithCallback<T>({
    required String name,
    required Future<T> Function() apiCall,
    void Function(int durationMs)? onComplete,
  }) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      final result = await apiCall();
      stopwatch.stop();
      
      final durationMs = stopwatch.elapsedMilliseconds;
      print('⏱️ [Flutter] [$name] took ${durationMs}ms');
      
      onComplete?.call(durationMs);
      
      return result;
    } catch (e) {
      stopwatch.stop();
      final durationMs = stopwatch.elapsedMilliseconds;
      print('❌ [Flutter] [$name] failed after ${durationMs}ms: $e');
      rethrow;
    }
  }

  /// Compare API response time with expected time
  /// Useful for testing or performance monitoring
  /// 
  /// Returns true if within expected time, false if slow
  static Future<bool> measureAndCompare<T>({
    required String name,
    required Future<T> Function() apiCall,
    required int expectedMaxMs,
  }) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      await apiCall();
      stopwatch.stop();
      
      final durationMs = stopwatch.elapsedMilliseconds;
      final isWithinExpected = durationMs <= expectedMaxMs;
      
      if (isWithinExpected) {
        print('✅ [Flutter] [$name] ${durationMs}ms (expected: <${expectedMaxMs}ms)');
      } else {
        print('❌ [Flutter] [$name] ${durationMs}ms (expected: <${expectedMaxMs}ms) - TOO SLOW');
      }
      
      return isWithinExpected;
    } catch (e) {
      stopwatch.stop();
      print('❌ [Flutter] [$name] failed: $e');
      return false;
    }
  }
}

