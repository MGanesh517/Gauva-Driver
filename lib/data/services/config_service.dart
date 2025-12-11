import 'package:dio/dio.dart';
import 'package:gauva_driver/core/config/environment.dart';
import 'package:gauva_driver/data/services/api/dio_client.dart';

import '../../core/config/api_endpoints.dart';
import '../../domain/interfaces/config_service_interface.dart';

class ConfigServiceImpl implements IConfigService {
  final DioClient dioClient;

  ConfigServiceImpl({required this.dioClient});
  @override
  Future<Response> getCarColors() async {
    final String url = '${Environment.baseUrl}/api${ApiEndpoints.getCarColors}';
    return await dioClient.dio.get(url);
  }

  @override
  Future<Response> getCarModels() async {
    final String url = '${Environment.baseUrl}/api${ApiEndpoints.getCarModels}';
    return await dioClient.dio.get(url);
  }
}
