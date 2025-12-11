import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gauva_driver/core/utils/helpers.dart';
import 'package:gauva_driver/data/repositories/interfaces/ride_repo_interface.dart';
import '../../../core/state/app_state.dart';
import '../../../data/models/order_response/order_model/order/order.dart';
import '../../../data/services/local_storage_service.dart';

class SliderButtonNotifier extends StateNotifier<AppState<Order>> {
  final IRideRepo rideRepo;
  final Ref ref;

  SliderButtonNotifier({required this.ref, required this.rideRepo}) : super(const AppState.initial());

  Future<void> saveOrderStatus({required String status, Function(Order? data)? onSuccess}) async {
    state = const AppState.loading();
    final result = await rideRepo.saveRideStatus(orderId: await LocalStorageService().getOrderId() ?? 0, status: status);

    result.fold(
      (failure) {
        showNotification(message: failure.message);
        state = AppState.error(failure);
      },
      (data) {
        state = AppState.success(data.data!);
        if (onSuccess != null) {
          onSuccess(data.data);
        }
      },
    );
  }

  void resetStateAfterDelay() {
    Future.delayed(Duration.zero, () {
      state = const AppState.initial();
    });
  }
}
