import 'package:dartz/dartz.dart';
import 'package:gauva_driver/core/errors/failure.dart';
import 'package:gauva_driver/data/models/common_response.dart';
import 'package:gauva_driver/data/repositories/base_repository.dart';
import 'package:gauva_driver/data/repositories/interfaces/cancel_ride_repo_interface.dart';
import '../../domain/interfaces/cancel_ride_service_interface.dart';

class CancelRideRepoImpl extends BaseRepository implements ICancelRideRepo {
  final ICancelRideService rideService;

  CancelRideRepoImpl({required this.rideService});

  @override
  Future<Either<Failure, CommonResponse>> cancelRide({required int? orderId}) async => await safeApiCall(() async {
    final response = await rideService.cancelRide(orderId: orderId);
    return CommonResponse.fromJson(response.data);
  });
}
