import 'package:dio/dio.dart';

import '../../core/config/api_endpoints.dart';
import '../../domain/interfaces/report_service_interface.dart';
import 'api/dio_client.dart';

class ReportService implements IReportService {
  final DioClient dioClient;

  ReportService({required this.dioClient});
  @override
  Future<Response> getReportType()async => await dioClient.dio
        .get(ApiEndpoints.getReportTypes,);
  @override
  Future<Response> submitReport({required int? orderId, String? reportName, required String? details}) async => await dioClient.dio
        .post(ApiEndpoints.submitReport, data: {'order_id': orderId, 'report_type': reportName, 'note': details});

}
