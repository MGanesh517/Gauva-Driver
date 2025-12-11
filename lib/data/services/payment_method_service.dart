import 'package:dio/dio.dart';
import 'package:gauva_driver/domain/interfaces/payment_method_service_interface.dart';
import '../../core/config/api_endpoints.dart';
import 'api/dio_client.dart';

class PaymentMethodService implements IPaymentMethodsService {
  final DioClient dioClient;

  PaymentMethodService({required this.dioClient});

  @override
  Future<Response> getPaymentMethods() async => dioClient.dio.get(ApiEndpoints.paymentMethods);
}
