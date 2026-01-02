import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/state/app_state.dart';
import '../../../data/models/subscription/driver_subscription_model.dart';
import '../../../data/models/subscription/subscription_plan_model.dart';
import '../../../data/repositories/interfaces/subscription_repo_interface.dart';
import '../../../data/models/subscription/purchase_subscription_response.dart';

class SubscriptionNotifier extends StateNotifier<AppState<List<SubscriptionPlan>>> {
  final ISubscriptionRepo subscriptionRepo;

  SubscriptionNotifier({required this.subscriptionRepo}) : super(const AppState.initial());

  Future<void> getPlans() async {
    state = const AppState.loading();
    final result = await subscriptionRepo.getPlans();
    result.fold((failure) => state = AppState.error(failure), (data) => state = AppState.success(data));
  }
}

class CurrentSubscriptionNotifier extends StateNotifier<AppState<DriverSubscription?>> {
  final ISubscriptionRepo subscriptionRepo;

  CurrentSubscriptionNotifier({required this.subscriptionRepo}) : super(const AppState.initial());

  Future<void> getCurrentSubscription() async {
    state = const AppState.loading();
    final result = await subscriptionRepo.getCurrentSubscription();
    result.fold((failure) => state = AppState.error(failure), (data) => state = AppState.success(data));
  }
}

class PurchaseSubscriptionNotifier extends StateNotifier<AppState<PurchaseSubscriptionResponse?>> {
  final ISubscriptionRepo subscriptionRepo;

  PurchaseSubscriptionNotifier({required this.subscriptionRepo}) : super(const AppState.initial());

  Future<void> purchaseSubscription({
    required int planId,
    required Function(PurchaseSubscriptionResponse) onSuccess,
    required Function(String) onError,
  }) async {
    state = const AppState.loading();
    final result = await subscriptionRepo.purchaseSubscription(planId: planId);
    result.fold(
      (failure) {
        state = AppState.error(failure);
        onError(failure.message);
      },
      (data) {
        state = AppState.success(data);
        onSuccess(data);
      },
    );
  }
}

class PaymentVerificationNotifier extends StateNotifier<AppState<bool>> {
  final ISubscriptionRepo subscriptionRepo;

  PaymentVerificationNotifier({required this.subscriptionRepo}) : super(const AppState.initial());

  Future<void> verifyPayment({
    required String orderId,
    String? paymentId,
    required Function() onSuccess,
    required Function(String) onError,
  }) async {
    state = const AppState.loading();
    final result = await subscriptionRepo.verifyPayment(orderId: orderId, paymentId: paymentId);
    result.fold(
      (failure) {
        state = AppState.error(failure);
        onError(failure.message);
      },
      (success) {
        state = AppState.success(success);
        onSuccess();
      },
    );
  }
}
