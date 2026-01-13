import 'package:dio/dio.dart';

/// Utility for making parallel API calls
/// Use this when you need to fetch multiple endpoints simultaneously
class ParallelApiCalls {
  /// Execute multiple API calls in parallel
  /// Returns a map of results keyed by the provided keys
  static Future<Map<String, Response>> execute({
    required Map<String, Future<Response>> calls,
  }) async {
    final results = <String, Response>{};
    final errors = <String, dynamic>{};
    
    // Execute all calls in parallel with error handling
    final futures = <String, Future<Response?>>{};
    
    for (final entry in calls.entries) {
      futures[entry.key] = entry.value.then<Response?>((response) => response).catchError((error) {
        errors[entry.key] = error;
        // Return a dummy response to satisfy type system, we'll filter it out
        return Response(
          requestOptions: RequestOptions(path: entry.key),
          statusCode: 500,
        );
      });
    }
    
    // Wait for all to complete
    final responses = await Future.wait(futures.values);
    
    // Process results (filter out error responses)
    int index = 0;
    for (final key in futures.keys) {
      final response = responses[index];
      if (response != null && 
          response.statusCode != null && 
          response.statusCode! >= 200 && 
          response.statusCode! < 300) {
        results[key] = response;
      }
      index++;
    }
    
    // If there are errors, log them
    if (errors.isNotEmpty) {
      print('⚠️ Parallel API calls errors: $errors');
    }
    
    return results;
  }
  
  /// Execute multiple API calls and return first successful result
  /// Useful for fallback scenarios
  static Future<Response?> executeWithFallback({
    required List<Future<Response>> calls,
  }) async {
    final futures = calls.map((call) => call.catchError((e) {
      // Return a dummy response on error, we'll filter it out
      return Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 500,
      );
    }));
    final results = await Future.wait(futures);
    
    // Return first successful result (statusCode 200-299)
    for (final result in results) {
      if (result.statusCode != null && result.statusCode! >= 200 && result.statusCode! < 300) {
        return result;
      }
    }
    
    return null;
  }
}
