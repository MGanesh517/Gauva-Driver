import 'package:dio/dio.dart';

abstract class ISubscriptionService {
  Future<Response> getPlans();
  Future<Response> getCurrentSubscription();
  Future<Response> purchaseSubscription({required int planId, String? couponCode});
  Future<Response> verifyPayment({required String orderId, String? paymentId});
  Future<Response> getHistory();
  Future<Response> getCoupons();
}
