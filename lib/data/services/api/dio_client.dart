import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../../core/config/environment.dart';
import 'dio_interceptors.dart';
import 'background_transformer.dart';

class DioClient {
  final Dio dio;

  DioClient({String? baseUrl})
    : dio = Dio(
        BaseOptions(
          // Optimized timeouts: Fast failure detection, but enough time for normal requests
          // Postman uses similar timeouts - we should match that for consistency
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          connectTimeout: const Duration(seconds: 15), // Fast connection timeout
          baseUrl: baseUrl ?? Environment.apiUrl,
          contentType: 'application/json',
          headers: {
            'Accept': 'application/json',
            // Enable compression if backend supports it
            'Accept-Encoding': 'gzip, deflate',
          },
          // Enable persistent connections (HTTP keep-alive) - reduces connection overhead
          persistentConnection: true,
          followRedirects: true,
          maxRedirects: 5,
        ),
      ) {
    // Use BackgroundTransformer for better performance (JSON parsing in isolate)
    dio.transformer = FlutterComputeTransformer();

    // Add interceptors in order
    dio.interceptors.add(DioInterceptors());
    dio.interceptors.add(InterceptorsWrapper());

    // Only enable PrettyDioLogger in debug mode (not in release builds)
    // This significantly improves performance in production
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: false, // Disabled for performance
          requestBody: false,
          responseBody: false,
          responseHeader: false,
          compact: true,
          maxWidth: 100,
        ),
      );
    }
  }
}
