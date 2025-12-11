import 'package:dartz/dartz.dart';
import 'package:gauva_driver/data/models/common_response.dart';
import 'package:gauva_driver/data/models/order_response/order_model/points/points.dart';
import 'package:gauva_driver/data/models/route_info_model.dart';

import '../../../core/errors/failure.dart';

abstract class IGoogleAPIRepo {
  Future<Either<Failure, RouteInfo>> fetchWayPoints({required Points? waypoints});
  Future<Either<Failure, CommonResponse>> sendTravelInfo({required Map<String, dynamic> info});
}
