import 'package:dartz/dartz.dart' hide Order;
import 'package:gauva_driver/data/models/order_response/order_detail/order_detail_model.dart';
import '../../../core/errors/failure.dart';
import '../../models/common_response.dart';
import '../../models/order_response/order_model/order/order.dart';
import '../../models/order_response/tip_model/trip_model.dart';

abstract class IRideRepo {
  Future<Either<Failure, OrderDetailModel>> rideOrder({required int orderId, required String status});
  Future<Either<Failure, OrderDetailModel>> orderDetails({required int orderId});
  Future<Either<Failure, OrderDetailModel>> saveRideStatus({required int orderId, required String status});
  Future<Either<Failure, CommonResponse>> cancelRide({required int? orderId});
  Future<Either<Failure, TripModel>> checkActiveTrip();

  // New Driver Ride APIs
  Future<Either<Failure, OrderDetailModel>> getCurrentRide({required int driverId});
  Future<Either<Failure, List<Order>>> getStartedRides();
  Future<Either<Failure, List<Order>>> getAllocatedRides();
  Future<Either<Failure, List<Order>>> getCompletedRides();
  Future<Either<Failure, OrderDetailModel>> acceptRide({required int rideId});
  Future<Either<Failure, CommonResponse>> declineRide({required int rideId});
  Future<Either<Failure, OrderDetailModel>> startRide({required int rideId, required String otp});
  Future<Either<Failure, OrderDetailModel>> completeRide({required int rideId});
  Future<Either<Failure, OrderDetailModel>> getRideDetails({required int rideId});
}
