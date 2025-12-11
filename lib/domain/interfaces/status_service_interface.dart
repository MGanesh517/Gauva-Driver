import 'package:dio/dio.dart';

abstract class IStatusService {
  Future<Response> updateOnlineStatus({required String status});
  Future<Response> updateRadius({required int radius});
}
