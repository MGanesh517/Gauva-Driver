import 'package:dartz/dartz.dart';
import '../../../core/errors/failure.dart';
import '../../models/common_response.dart';

abstract class ICancelRideRepo {
  Future<Either<Failure, CommonResponse>> cancelRide({required int? orderId});
}
