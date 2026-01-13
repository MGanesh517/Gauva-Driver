import 'package:dio/dio.dart';
import 'package:gauva_driver/core/utils/response_cache.dart';
import 'package:gauva_driver/data/services/api/dio_client.dart';
import 'package:gauva_driver/domain/interfaces/dashboard_service_interface.dart';

import '../../core/config/api_endpoints.dart';

class DashboardServiceImpl implements IDashboardService {
  final DioClient dioClient;
  
  // Short cache for dashboard (30 seconds - balances freshness with performance)
  static const _dashboardCacheDuration = Duration(seconds: 30);

  DashboardServiceImpl({required this.dioClient});
  
  @override
  Future<Response> getDashboard() async {
    const cacheKey = 'dashboard';
    
    // Check cache first (short duration for freshness)
    final cached = ResponseCache.getCached(cacheKey, maxAge: _dashboardCacheDuration);
    if (cached != null) {
      print('✅ Using cached dashboard (saved ~200-500ms)');
      return cached;
    }
    
    // Fetch from API
    final response = await dioClient.dio.get(ApiEndpoints.dashboard);
    
    // Cache the response
    if (response.statusCode == 200) {
      ResponseCache.setCached(cacheKey, response);
    }
    
    return response;
  }
  
  /// Clear dashboard cache (call when driver status changes, etc.)
  static void clearCache() {
    ResponseCache.clearCache('dashboard');
  }
}
