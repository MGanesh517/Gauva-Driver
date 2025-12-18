import 'package:dio/dio.dart';

abstract class IRideService {
  Future<Response> rideOrder({required int orderId, required String status});
  Future<Response> orderDetails({required int orderId});
  Future<Response> saveRideStatus({required int orderId, required String status});
  Future<Response> cancelRide({required int? orderId});
  Future<Response> checkActiveTrip();

  // New Driver Ride APIs
  Future<Response> getCurrentRide({required int driverId});
  Future<Response> getStartedRides();
  Future<Response> getAllocatedRides();
  Future<Response> getCompletedRides();
  Future<Response> acceptRide({required int rideId, required int otp});
  Future<Response> declineRide({required int rideId});
  Future<Response> startRide({required int rideId, required int otp});
  Future<Response> completeRide({required int rideId});
  Future<Response> getRideDetails({required int rideId});
  Future<Response> goToPickup({required int orderId});
}
