import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gauva_driver/core/state/app_state.dart';
import 'package:gauva_driver/data/models/order_response/order_model/order/order.dart';
import 'package:gauva_driver/data/repositories/interfaces/ride_history_repo_interface.dart';

class RideHistoryNotifier extends StateNotifier<AppState<List<Order>>> {
  final Ref ref;
  final IRideHistoryRepo service;
  RideHistoryNotifier(this.ref, this.service) : super(const AppState.initial());

  Future<void> getRideHistory({String? status, String? date, int page = 0, int size = 100}) async {
    state = const AppState.loading();
    final result = await service.getRideHistory(status: status, date: date, page: page, size: size);

    result.fold(
      (failure) {
        state = AppState.error(failure);
      },
      (data) {
        state = AppState.success(data.content ?? []);
      },
    );
  }
}
