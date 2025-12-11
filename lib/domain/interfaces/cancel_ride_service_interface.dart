import 'package:dio/dio.dart';

abstract class ICancelRideService {
  Future<Response> cancelRide({required int? orderId});
}
