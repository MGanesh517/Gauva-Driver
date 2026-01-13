import 'package:dio/dio.dart';
import '../../core/config/api_endpoints.dart';
import '../../core/utils/response_cache.dart';
import '../../domain/interfaces/country_list_service_interface.dart';
import 'api/dio_client.dart';

class CountryListService implements ICountryListService {
  final DioClient dioClient;
  
  // Cache duration for country list (1 hour - rarely changes)
  static const _countryListCacheDuration = Duration(hours: 1);

  CountryListService({required this.dioClient});
  
  @override
  Future<Response> getCountryList() async {
    const cacheKey = 'country_list';
    
    // Check cache first
    final cached = ResponseCache.getCached(cacheKey, maxAge: _countryListCacheDuration);
    if (cached != null) {
      print('✅ Using cached country list');
      return cached;
    }
    
    // Fetch from API
    final response = await dioClient.dio.get(ApiEndpoints.getCountryList);
    
    // Cache the response
    if (response.statusCode == 200) {
      ResponseCache.setCached(cacheKey, response);
    }
    
    return response;
  }
  
  /// Clear country list cache
  static void clearCache() {
    ResponseCache.clearCache('country_list');
  }
}
