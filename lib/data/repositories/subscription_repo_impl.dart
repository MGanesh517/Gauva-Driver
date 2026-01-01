import 'package:dartz/dartz.dart';
import '../../core/errors/failure.dart';
import '../../domain/interfaces/subscription_service_interface.dart';
import '../models/subscription/subscription_plan_model.dart';
import '../models/subscription/driver_subscription_model.dart';
import '../models/subscription/purchase_subscription_response.dart';
import '../repositories/base_repository.dart';
import 'interfaces/subscription_repo_interface.dart';

class SubscriptionRepoImpl extends BaseRepository implements ISubscriptionRepo {
  final ISubscriptionService subscriptionService;

  SubscriptionRepoImpl({required this.subscriptionService});

  @override
  Future<Either<Failure, List<SubscriptionPlan>>> getPlans() async => await safeApiCall(() async {
    final response = await subscriptionService.getPlans();
    return (response.data as List).map((e) => SubscriptionPlan.fromJson(e)).toList();
  });

  @override
  Future<Either<Failure, DriverSubscription?>> getCurrentSubscription() async => await safeApiCall(() async {
    final response = await subscriptionService.getCurrentSubscription();
    if (response.data is Map && (response.data as Map).containsKey('message')) {
      // "No active subscription" case
      return null;
    }
    return DriverSubscription.fromJson(response.data);
  });

  @override
  Future<Either<Failure, PurchaseSubscriptionResponse>> purchaseSubscription({required int planId}) async =>
      await safeApiCall(() async {
        final response = await subscriptionService.purchaseSubscription(planId: planId);
        return PurchaseSubscriptionResponse.fromJson(response.data);
      });

  @override
  Future<Either<Failure, bool>> verifyPayment({required String orderId, String? paymentId}) async =>
      await safeApiCall(() async {
        await subscriptionService.verifyPayment(orderId: orderId, paymentId: paymentId);
        // Assuming 200 OK means success, returning true
        return true;
      });

  @override
  Future<Either<Failure, DriverSubscription?>> getHistory() async => await safeApiCall(() async {
    final response = await subscriptionService.getHistory();
    if (response.data is Map && (response.data as Map).containsKey('message')) {
      return null;
    }
    // History endpoint structure from docs: { "subscription": { ... } }
    // But for "get history", let's check if it returns a list or single object based on docs.
    // Docs say: "Get subscription history (currently returns active subscription if exists)"
    // Response body example: { "subscription": { ... } }
    final data = response.data;
    if (data is Map && data.containsKey('subscription')) {
      return DriverSubscription.fromJson(data['subscription']);
    }
    return null;
  });
}
