import 'package:dio/dio.dart';
import 'package:gauva_driver/core/config/environment.dart';
import 'package:gauva_driver/core/utils/response_cache.dart';
import 'package:gauva_driver/data/services/api/dio_client.dart';

import '../../core/config/api_endpoints.dart';
import '../../domain/interfaces/config_service_interface.dart';

class ConfigServiceImpl implements IConfigService {
  final DioClient dioClient;
  
  // Cache duration for static config data (30 minutes - these rarely change)
  static const _configCacheDuration = Duration(minutes: 30);

  ConfigServiceImpl({required this.dioClient});
  
  @override
  Future<Response> getCarColors() async {
    final String url = '${Environment.baseUrl}/api${ApiEndpoints.getCarColors}';
    final cacheKey = 'car_colors';
    
    // Check cache first
    final cached = ResponseCache.getCached(cacheKey, maxAge: _configCacheDuration);
    if (cached != null) {
      print('✅ Using cached car colors');
      return cached;
    }
    
    // Fetch from API
    final response = await dioClient.dio.get(url);
    
    // Cache the response
    if (response.statusCode == 200) {
      ResponseCache.setCached(cacheKey, response);
    }
    
    return response;
  }

  @override
  Future<Response> getCarModels() async {
    final String url = '${Environment.baseUrl}/api${ApiEndpoints.getCarModels}';
    final cacheKey = 'car_models';
    
    // Check cache first
    final cached = ResponseCache.getCached(cacheKey, maxAge: _configCacheDuration);
    if (cached != null) {
      print('✅ Using cached car models');
      return cached;
    }
    
    // Fetch from API
    final response = await dioClient.dio.get(url);
    
    // Cache the response
    if (response.statusCode == 200) {
      ResponseCache.setCached(cacheKey, response);
    }
    
    return response;
  }

  @override
  Future<Response> getWebSocketUrl() async {
    final String url = '${Environment.baseUrl}/api${ApiEndpoints.getWebSocketUrl}';
    // WebSocket URL might change, so cache for shorter duration (5 minutes)
    final cacheKey = 'websocket_url';
    
    final cached = ResponseCache.getCached(cacheKey, maxAge: const Duration(minutes: 5));
    if (cached != null) {
      return cached;
    }
    
    final response = await dioClient.dio.get(url);
    
    if (response.statusCode == 200) {
      ResponseCache.setCached(cacheKey, response);
    }
    
    return response;
  }
  
  /// Clear all config cache (useful when configs are updated)
  static void clearCache() {
    ResponseCache.clearCache('car_colors');
    ResponseCache.clearCache('car_models');
    ResponseCache.clearCache('websocket_url');
  }
}
