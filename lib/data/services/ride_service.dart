import 'package:dio/dio.dart';

import '../../core/config/api_endpoints.dart';
import '../../domain/interfaces/ride_service_interface.dart';
import 'api/dio_client.dart';

class RideService implements IRideService {
  final DioClient dioClient;

  RideService({required this.dioClient});
  @override
  Future<Response> rideOrder({required int orderId, required String status}) async =>
      await dioClient.dio.get('${ApiEndpoints.orderRide}/$orderId/$status');

  @override
  Future<Response> orderDetails({required int orderId}) async =>
      await dioClient.dio.get('${ApiEndpoints.orderRide}/$orderId');

  @override
  Future<Response> saveRideStatus({required int orderId, required String status}) async =>
      await dioClient.dio.get('${ApiEndpoints.orderRide}/$orderId/$status/status');

  @override
  Future<Response> cancelRide({required int? orderId}) async =>
      await dioClient.dio.get('${ApiEndpoints.cancelRide}/$orderId');

  @override
  Future<Response> checkActiveTrip() async {
    // Use the new API endpoint: GET /api/v1/driver/rides/started
    // This doesn't require driverId in the path as it's extracted from the token
    return await dioClient.dio.get('/v1/driver/rides/started');
  }

  @override
  Future<Response> getCurrentRide({required int driverId}) async {
    return await dioClient.dio.get('${ApiEndpoints.getCurrentRide}/$driverId/current_ride');
  }

  @override
  Future<Response> getStartedRides() async {
    return await dioClient.dio.get(ApiEndpoints.getStartedRides);
  }

  @override
  Future<Response> getAllocatedRides() async {
    return await dioClient.dio.get(ApiEndpoints.getAllocatedRides);
  }

  @override
  Future<Response> getCompletedRides() async {
    return await dioClient.dio.get(ApiEndpoints.getCompletedRides);
  }

  @override
  Future<Response> acceptRide({required int rideId}) async {
    return await dioClient.dio.post('${ApiEndpoints.acceptRide}/$rideId/accept');
  }

  @override
  Future<Response> declineRide({required int rideId}) async {
    return await dioClient.dio.post('${ApiEndpoints.declineRide}/$rideId/decline');
  }

  @override
  Future<Response> startRide({required int rideId, required String otp}) async {
    return await dioClient.dio.post('${ApiEndpoints.startRide}/$rideId/start', data: {'otp': otp});
  }

  @override
  Future<Response> completeRide({required int rideId}) async {
    return await dioClient.dio.post('${ApiEndpoints.completeRide}/$rideId/complete');
  }

  @override
  Future<Response> getRideDetails({required int rideId}) async {
    return await dioClient.dio.get('${ApiEndpoints.getRideDetails}/$rideId');
  }
}
