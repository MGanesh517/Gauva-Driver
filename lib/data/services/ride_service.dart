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
  Future<Response> orderDetails({required int orderId}) async {
    // Use the new v1 API endpoint: GET /api/v1/ride/{rideId}
    // This matches the HTML tool's flow: /api/v1/ride/{id}
    // The orderId is actually the rideId in the new API
    return await dioClient.dio.get('${ApiEndpoints.getRideDetails}/$orderId');
  }

  @override
  Future<Response> saveRideStatus({required int orderId, required String status}) async {
    // Fix URL construction: manually construct full URL to ensure correct path separation
    // API: GET /api/driver/order/{id}/{status}/status
    final baseUrl = dioClient.dio.options.baseUrl; // e.g., https://.../api
    final endpointPath = ApiEndpoints.orderRide; // e.g., driver/order
    final fullUrl =
        '$baseUrl/$endpointPath/$orderId/$status/status'; // e.g., https://.../api/driver/order/48/picked_up/status

    print('💾 RideService: Saving ride status: $status for order $orderId');
    print('💾 RideService: Constructed Full URL: $fullUrl');
    return await dioClient.dio.get(fullUrl);
  }

  @override
  Future<Response> cancelRide({required int? orderId}) async =>
      await dioClient.dio.get('${ApiEndpoints.cancelRide}/$orderId');

  @override
  Future<Response> checkActiveTrip() async {
    // Use the new API endpoint: GET /api/v1/driver/rides/started
    // This doesn't require driverId in the path as it's extracted from the token
    return await dioClient.dio.get(ApiEndpoints.getCurrentRides);
  }

  @override
  Future<Response> getCurrentRide({required int driverId}) async {
    // Use the new endpoint: GET /api/v1/driver/rides/current
    // Driver ID is extracted from token, no need to pass in URL
    // This matches the HTML tool's flow
    return await dioClient.dio.get(ApiEndpoints.getCurrentRides);
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
  Future<Response> acceptRide({required int rideId, required int otp}) async {
    // Match HTML tool: POST /api/v1/ride/{rideId}/accept with {otp: <otp>}
    final url = '${ApiEndpoints.acceptRide}/$rideId/accept';
    final body = {'otp': otp};
    print('✅ RideService: Accepting ride $rideId with OTP $otp');
    print('✅ RideService: URL: $url');
    print('✅ RideService: Body: $body');
    return await dioClient.dio.post(url, data: body);
  }

  @override
  Future<Response> declineRide({required int rideId}) async {
    // Match HTML tool: POST /api/v1/ride/{rideId}/decline (no body)
    final url = '${ApiEndpoints.declineRide}/$rideId/decline';
    print('❌ RideService: Declining ride $rideId');
    print('❌ RideService: URL: $url');
    return await dioClient.dio.post(url);
  }

  @override
  Future<Response> startRide({required int rideId, required int otp}) async {
    // Match HTML tool: POST /api/v1/ride/{rideId}/start with {otp: <otp>}
    final url = '${ApiEndpoints.startRide}/$rideId/start';
    final body = {'otp': otp};
    print('🚀 RideService: Starting ride $rideId with OTP $otp');
    print('🚀 RideService: URL: $url');
    print('🚀 RideService: Body: $body');
    print('🚀 RideService: Full URL will be: ${dioClient.dio.options.baseUrl}$url');
    return await dioClient.dio.post(url, data: body);
  }

  @override
  Future<Response> completeRide({required int rideId}) async {
    return await dioClient.dio.post('${ApiEndpoints.completeRide}/$rideId/complete');
  }

  @override
  Future<Response> getRideDetails({required int rideId}) async {
    return await dioClient.dio.get('${ApiEndpoints.getRideDetails}/$rideId');
  }

  @override
  Future<Response> goToPickup({required int orderId}) async {
    // API: POST /api/driver/order/{id}/go_to_pickup/status
    // Fix URL construction: manually construct full URL to ensure correct path separation
    final baseUrl = dioClient.dio.options.baseUrl; // e.g., https://.../api
    final endpointPath = ApiEndpoints.goToPickup; // e.g., driver/order
    final fullUrl =
        '$baseUrl/$endpointPath/$orderId/go_to_pickup/status'; // e.g., https://.../api/driver/order/43/go_to_pickup/status

    print('🚗 RideService: Going to pickup for order $orderId');
    print('🚗 RideService: Constructed Full URL: $fullUrl');
    return await dioClient.dio.post(fullUrl);
  }
}
