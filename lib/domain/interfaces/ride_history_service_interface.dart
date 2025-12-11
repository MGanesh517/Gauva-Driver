import 'package:dio/dio.dart';

abstract class IRideHistoryService {
  Future<Response> getRideHistory({String? status, String? date});
}
