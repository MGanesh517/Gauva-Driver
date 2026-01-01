import 'package:dartz/dartz.dart';
import '../../../core/errors/failure.dart';
import '../../models/subscription/subscription_plan_model.dart';
import '../../models/subscription/driver_subscription_model.dart';
import '../../models/subscription/purchase_subscription_response.dart';

abstract class ISubscriptionRepo {
  Future<Either<Failure, List<SubscriptionPlan>>> getPlans();
  Future<Either<Failure, DriverSubscription?>> getCurrentSubscription();
  Future<Either<Failure, PurchaseSubscriptionResponse>> purchaseSubscription({required int planId});
  Future<Either<Failure, bool>> verifyPayment({required String orderId, String? paymentId});
  Future<Either<Failure, DriverSubscription?>> getHistory();
}
