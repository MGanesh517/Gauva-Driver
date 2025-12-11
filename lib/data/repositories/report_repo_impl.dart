import 'package:dartz/dartz.dart';
import '../../core/errors/failure.dart';
import '../../domain/interfaces/report_service_interface.dart';
import '../models/common_response.dart';
import '../models/report_response/report_type_response.dart';
import 'base_repository.dart';
import 'interfaces/report_repo_interface.dart';

class ReportRepoImpl extends BaseRepository implements IReportRepo {
  final IReportService reportService;

  ReportRepoImpl({required this.reportService});

  @override
  Future<Either<Failure, ReportTypeResponse>> getReportType() async => await safeApiCall(()async{
      final response = await reportService.getReportType();
      try {
        return ReportTypeResponse.fromJson(response.data);
      } catch (e) {
        throw Exception('Parsing error');
      }

    });

  @override
  Future<Either<Failure, CommonResponse>> submitReport({required int? orderId, String? reportName, required String? details}) async => await safeApiCall(()async{
      final response = await reportService.submitReport(orderId: orderId, reportName: reportName, details: details);
      try {
        return CommonResponse.fromJson(response.data);
      } catch (e) {
        throw Exception('Parsing error');
      }

    });
}