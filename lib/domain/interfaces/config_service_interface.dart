import 'package:dio/dio.dart';

abstract class IConfigService {
  Future<Response> getCarModels();
  Future<Response> getCarColors();
}
