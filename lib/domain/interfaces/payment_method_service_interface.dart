import 'package:dio/dio.dart';

abstract class IPaymentMethodsService {
  Future<Response> getPaymentMethods();
}
