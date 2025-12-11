import 'package:dartz/dartz.dart';
import 'package:gauva_driver/data/models/driver_radius_update_response/driver_radius_update_response.dart';
import 'package:gauva_driver/data/models/online_status_update_response/online_status_update_response.dart';

import '../../../core/errors/failure.dart';

abstract class IStatusRepo {
  Future<Either<Failure, OnlineStatusUpdateResponse>> updateOnlineStatus({required String status});
  Future<Either<Failure, DriverRadiusUpdateResponse>> updateRadius({required int radius});
}
