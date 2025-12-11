import 'package:dio/dio.dart';

import '../../core/config/api_endpoints.dart';
import '../../domain/interfaces/cancel_ride_service_interface.dart';
import 'api/dio_client.dart';

class CancelRideService implements ICancelRideService {
  final DioClient dioClient;

  CancelRideService({required this.dioClient});


  @override
  Future<Response> cancelRide({required int? orderId}) async => await dioClient.dio.get('${ApiEndpoints.cancelRide}/$orderId',);

}
