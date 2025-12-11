import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../models/common_response.dart';
import '../../models/report_response/report_type_response.dart';

abstract class IReportRepo {
  Future<Either<Failure, ReportTypeResponse>> getReportType();
  Future<Either<Failure, CommonResponse>> submitReport({required int? orderId, String? reportName, required String? details});
}
