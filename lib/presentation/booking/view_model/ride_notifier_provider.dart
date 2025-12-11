import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gauva_driver/core/errors/failure.dart';
import 'package:gauva_driver/core/state/state_order.dart';
import 'package:gauva_driver/core/utils/helpers.dart';
import 'package:gauva_driver/data/repositories/interfaces/ride_repo_interface.dart';
import 'package:gauva_driver/presentation/booking/provider/home_providers.dart';
import 'package:gauva_driver/presentation/booking/provider/ride_providers.dart';
import 'package:gauva_driver/presentation/booking/view_model/loading_notifier.dart';
import '../../../core/state/app_state.dart';
import '../../../data/models/order_response/order_model/order/order.dart';
import '../../../data/services/local_storage_service.dart';
import '../../splash/provider/app_flow_providers.dart';
import '../provider/driver_providers.dart';

class RideOrderNotifier extends StateNotifier<AppStateOrder<Order?>> {
  final IRideRepo rideRepo;
  final Ref ref;

  RideOrderNotifier({required this.ref, required this.rideRepo}) : super(const AppStateOrder.loading());

  Future<void> orderDetails({required int orderId}) async {
    final previousData = _getPreviousDataOrNull();
    state = previousData != null ? AppStateOrder.success(previousData) : const AppStateOrder.loading();

    final result = await rideRepo.orderDetails(orderId: orderId);

    result.fold(
      (failure) {
        showNotification(message: failure.message);
        Future.delayed(const Duration(milliseconds: 600)).then((_) {
          ref.read(driverStatusNotifierProvider.notifier).online();
        });
        // state unchanged → previous success data shown
      },
      (data) {
        state = AppStateOrder.success(data.data);
      },
    );
  }

  String currentStatus = '';
  Future<void> saveOrderStatus({
    required String status,
    Function(Order? data)? onSuccess,
    Function(Failure data)? onError,
  }) async {
    currentStatus = status;
    final loadingNotifier = ref.read(loadingProvider.notifier)..startLoading();
    final previousData = _getPreviousDataOrNull();
    state = previousData != null ? AppStateOrder.success(previousData) : const AppStateOrder.loading();

    final result = await rideRepo.saveRideStatus(orderId: await LocalStorageService().getOrderId() ?? 0, status: status);

    result.fold(
      (failure) {
        showNotification(message: failure.message);
        onError != null ? onError(failure) : null;
        // if(failure.code == 422){
        //   NavigationService.pop();
        // }
        // state unchanged → keep previous UI
      },
      (data) {
        showNotification(message: data.message, isSuccess: true);
        state = AppStateOrder.success(data.data);
        if (onSuccess != null) {
          onSuccess(data.data);
        }
      },
    );
    loadingNotifier.stopLoading();
    currentStatus = '';
  }

  Future<void> setOrderData(Order order) async {
    await LocalStorageService().saveOrderId(order.id);
    state = AppStateOrder.success(order);
  }

  void navigateToHome() {
    LocalStorageService().clearOrderId();

    ref.read(bookingNotifierProvider.notifier)
      ..stopLocationUpdates()
      ..resetToInitial();
  }

  void resetStateAfterDelay() {
    Future.delayed(Duration.zero, () {
      state = const AppStateOrder.loading();
    });
  }

  Order? _getPreviousDataOrNull() => state.maybeWhen(success: (data) => data, orElse: () => null);
}

class CheckTripActivityNotifier extends StateNotifier<AppState<Order?>> {
  final IRideRepo rideRepo;
  final Ref ref;

  CheckTripActivityNotifier(this.rideRepo, this.ref) : super(const AppState.initial());
  Future<void> checkTripActivity({Function()? onSuccess}) async {
    final String? token = await LocalStorageService().getToken();
    if (token != null) {
      state = const AppState.loading();
      final result = await rideRepo.checkActiveTrip();
      result.fold((failure) => _handleFailure(failure), (data) {
        if (data.data?.order != null) {
          state = AppState.success(data.data!.order);
          ref.read(rideOrderNotifierProvider.notifier).setOrderData(data.data!.order!);
        } else {
          state = const AppState.success(null);
        }
        if (onSuccess != null) {
          onSuccess();
        }
      });
    }
    ref.read(appFlowViewModelProvider.notifier).setAppFlowState();
  }

  void _handleFailure(Failure failure) {
    state = AppState.error(failure);
    showNotification(message: failure.message);
    // Navigation to login commented out for design testing
    // Even if API fails with 401, don't navigate to login
  }
}
