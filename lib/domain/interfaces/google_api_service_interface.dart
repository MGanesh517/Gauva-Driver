import 'package:dio/dio.dart';
import 'package:gauva_driver/data/models/order_response/order_model/points/points.dart';

abstract class IGoogleApiService {
  Future<Response> fetchWayPoints({required Points? waypoints});
  Future<Response> sendTravelInfo({required Map<String, dynamic> info});
}
