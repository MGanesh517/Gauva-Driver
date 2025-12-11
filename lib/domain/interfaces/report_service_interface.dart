import 'package:dio/dio.dart';

abstract class IReportService {
  Future<Response> getReportType();
  Future<Response> submitReport({required int? orderId, String? reportName, required String? details});
}
