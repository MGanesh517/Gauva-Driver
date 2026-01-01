import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/subscription_repo_impl.dart';
import '../../../data/services/subscription_service.dart';
import '../../../domain/interfaces/subscription_service_interface.dart';
import '../../../data/repositories/interfaces/subscription_repo_interface.dart';
import '../../auth/provider/auth_providers.dart';
import '../view_model/subscription_notifier.dart';
import '../../../core/state/app_state.dart';
import '../../../data/models/subscription/driver_subscription_model.dart';
import '../../../data/models/subscription/subscription_plan_model.dart';
import '../../../data/models/subscription/purchase_subscription_response.dart';

// Service Provider
final subscriptionServiceProvider = Provider<ISubscriptionService>((ref) {
  return SubscriptionService(dioClient: ref.read(dioClientProvider));
});

// Repository Provider
final subscriptionRepoProvider = Provider<ISubscriptionRepo>((ref) {
  return SubscriptionRepoImpl(subscriptionService: ref.read(subscriptionServiceProvider));
});

// ViewModels Providers

final subscriptionPlansNotifierProvider = StateNotifierProvider<SubscriptionNotifier, AppState<List<SubscriptionPlan>>>((
  ref,
) {
  return SubscriptionNotifier(subscriptionRepo: ref.read(subscriptionRepoProvider));
});

final currentSubscriptionNotifierProvider =
    StateNotifierProvider<CurrentSubscriptionNotifier, AppState<DriverSubscription?>>((ref) {
      return CurrentSubscriptionNotifier(subscriptionRepo: ref.read(subscriptionRepoProvider));
    });

final purchaseSubscriptionNotifierProvider =
    StateNotifierProvider<PurchaseSubscriptionNotifier, AppState<PurchaseSubscriptionResponse?>>((ref) {
      return PurchaseSubscriptionNotifier(subscriptionRepo: ref.read(subscriptionRepoProvider));
    });

final paymentVerificationNotifierProvider = StateNotifierProvider<PaymentVerificationNotifier, AppState<bool>>(
  (ref) => PaymentVerificationNotifier(subscriptionRepo: ref.read(subscriptionRepoProvider)),
);
