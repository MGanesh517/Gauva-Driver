import 'package:dio/dio.dart';
import '../../core/config/api_endpoints.dart';
import '../../domain/interfaces/country_list_service_interface.dart';
import 'api/dio_client.dart';

class CountryListService implements ICountryListService {
  final DioClient dioClient;

  CountryListService({required this.dioClient});
  @override
  Future<Response> getCountryList() async => await dioClient.dio
      .get(ApiEndpoints.getCountryList,);
}
