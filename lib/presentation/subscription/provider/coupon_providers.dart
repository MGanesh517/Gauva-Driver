import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/state/app_state.dart';
import '../../../core/errors/failure.dart';
import '../../../data/models/coupon/coupon_model.dart';
import '../../../data/repositories/interfaces/subscription_repo_interface.dart';
import '../../subscription/provider/subscription_providers.dart';

// Coupon List Notifier
class CouponListNotifier extends StateNotifier<AppState<List<Coupon>>> {
  final ISubscriptionRepo subscriptionRepo;

  CouponListNotifier({required this.subscriptionRepo}) : super(const AppState.initial());

  Future<void> getCoupons() async {
    state = const AppState.loading();

    try {
      final result = await subscriptionRepo.getCoupons();
      result.fold((failure) => state = AppState.error(failure), (coupons) => state = AppState.success(coupons));
    } catch (e) {
      state = AppState.error(Failure(message: e.toString()));
    }
  }
}

// Provider for coupon list
final couponListNotifierProvider = StateNotifierProvider<CouponListNotifier, AppState<List<Coupon>>>((ref) {
  return CouponListNotifier(subscriptionRepo: ref.read(subscriptionRepoProvider));
});
