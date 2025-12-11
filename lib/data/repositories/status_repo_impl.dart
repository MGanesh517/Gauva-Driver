import 'package:dartz/dartz.dart';
import 'package:gauva_driver/core/errors/failure.dart';
import 'package:gauva_driver/data/models/driver_radius_update_response/driver_radius_update_response.dart';
import 'package:gauva_driver/data/models/online_status_update_response/online_status_update_response.dart';
import 'package:gauva_driver/data/repositories/base_repository.dart';
import 'package:gauva_driver/data/repositories/interfaces/status_repo_interface.dart';
import 'package:gauva_driver/domain/interfaces/status_service_interface.dart';

class StatusRepoImpl extends BaseRepository implements IStatusRepo {
  final IStatusService statusService;

  StatusRepoImpl({required this.statusService});

  @override
  Future<Either<Failure, OnlineStatusUpdateResponse>> updateOnlineStatus({required String status}) async =>
      await safeApiCall(() async {
        // Pass the status as-is, service will convert to boolean
        final response = await statusService.updateOnlineStatus(status: status);
        print('📦 Raw API Response: ${response.data}');
        final parsed = OnlineStatusUpdateResponse.fromJson(response.data);
        print('📦 Parsed Response - isOnline: ${parsed.isOnline}, message: ${parsed.message}');
        return parsed;
      });

  @override
  Future<Either<Failure, DriverRadiusUpdateResponse>> updateRadius({required int radius}) async =>
      await safeApiCall(() async {
        final response = await statusService.updateRadius(radius: radius);
        return DriverRadiusUpdateResponse.fromMap(response.data);
      });
}
