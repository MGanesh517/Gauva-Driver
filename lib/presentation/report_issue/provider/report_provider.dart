import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/state/app_state.dart';
import '../../../data/models/common_response.dart';
import '../../../data/models/report_response/report_type_response.dart';
import '../../../data/repositories/interfaces/report_repo_interface.dart';
import '../../../data/repositories/report_repo_impl.dart';
import '../../../data/services/report_service.dart';
import '../../../domain/interfaces/report_service_interface.dart';
import '../../auth/provider/auth_providers.dart';
import '../view_model/report_issue_notifier.dart';

final reportServiceProvider =
Provider<IReportService>((ref) => ReportService(dioClient: ref.read(dioClientChattingProvider)));

// Repo Provider
final reportRepoProvider = Provider<IReportRepo>((ref) => ReportRepoImpl( reportService: ref.read(reportServiceProvider),));

final selectReportTypeProvider = StateNotifierProvider<SelectedReportTypeNotifier, ReportTypes?>(
      (ref) => SelectedReportTypeNotifier(),
);

final reportTypesNotifierProvider = StateNotifierProvider<ReportTypeNotifier, AppState<List<ReportTypes>>>(
        (ref) => ReportTypeNotifier(ref: ref, reportRepo: ref.read(reportRepoProvider)));

final reportSubmitNotifierProvider = StateNotifierProvider<ReportSubmitNotifier, AppState<CommonResponse>>(
        (ref) => ReportSubmitNotifier(ref: ref, reportRepo: ref.read(reportRepoProvider)));