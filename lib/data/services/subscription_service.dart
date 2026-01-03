import 'package:dio/dio.dart';
import '../../core/config/api_endpoints.dart';
import '../../domain/interfaces/subscription_service_interface.dart';
import 'api/dio_client.dart';

class SubscriptionService implements ISubscriptionService {
  final DioClient dioClient;

  SubscriptionService({required this.dioClient});

  @override
  Future<Response> getPlans() async {
    return await dioClient.dio.get(ApiEndpoints.subscriptionPlans);
  }

  @override
  Future<Response> getCurrentSubscription() async {
    return await dioClient.dio.get(ApiEndpoints.currentSubscription);
  }

  @override
  Future<Response> purchaseSubscription({required int planId, String? couponCode}) async {
    final Map<String, dynamic> data = {'planId': planId};
    if (couponCode != null && couponCode.isNotEmpty) {
      data['couponCode'] = couponCode;
    }
    return await dioClient.dio.post(ApiEndpoints.purchaseSubscription, data: data);
  }

  @override
  Future<Response> verifyPayment({required String orderId, String? paymentId}) async {
    final Map<String, dynamic> body = {'orderId': orderId};
    if (paymentId != null) {
      body['paymentId'] = paymentId;
    }
    return await dioClient.dio.post(ApiEndpoints.verifySubscriptionPayment, data: body);
  }

  @override
  Future<Response> getHistory() async {
    return await dioClient.dio.get(ApiEndpoints.subscriptionHistory);
  }

  @override
  Future<Response> getCoupons() async {
    return await dioClient.dio.get(ApiEndpoints.coupons);
  }
}
