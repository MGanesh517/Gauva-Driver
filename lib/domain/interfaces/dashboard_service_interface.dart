import 'package:dio/dio.dart';

abstract class IDashboardService {
  Future<Response> getDashboard();
}
