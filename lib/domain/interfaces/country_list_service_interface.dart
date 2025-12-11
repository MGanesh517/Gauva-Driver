import 'package:dio/dio.dart';

abstract class ICountryListService {
  Future<Response> getCountryList();
}
