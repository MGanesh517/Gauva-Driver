import 'package:dartz/dartz.dart';
import 'package:gauva_driver/core/errors/failure.dart';
import 'package:gauva_driver/data/models/dashboard_model/dashboard_model.dart';
import 'package:gauva_driver/data/repositories/base_repository.dart';

import '../../domain/interfaces/dashboard_service_interface.dart';
import 'interfaces/dashboard_repo_interface.dart';

class DashboardRepoImpl extends BaseRepository implements IDashboardRepository {
  final IDashboardService dashboardService;
  DashboardRepoImpl({required this.dashboardService});
  @override
  Future<Either<Failure, DashboardModel>> getDashboard() async => await safeApiCall(() async {
    final response = await dashboardService.getDashboard();
    try {
      return DashboardModel.fromJson(response.data);
    } catch (e) {
      throw Exception(e);
    }
  });
}
