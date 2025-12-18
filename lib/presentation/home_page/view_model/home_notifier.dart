import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gauva_driver/core/state/app_state.dart';
import 'package:gauva_driver/data/models/dashboard_model/dashboard_model.dart';
import 'package:gauva_driver/data/repositories/interfaces/dashboard_repo_interface.dart';

import 'package:gauva_driver/presentation/booking/provider/driver_providers.dart';

class HomeNotifier extends StateNotifier<AppState<DashboardModel?>> {
  final Ref ref;
  final IDashboardRepository service;
  HomeNotifier(this.ref, this.service) : super(const AppState.initial());

  Future<void> getDashboard() async {
    state = const AppState.loading();
    final result = await service.getDashboard();

    result.fold(
      (failure) {
        state = AppState.error(failure);
      },
      (data) {
        // Sync Driver Status
        if (data.driverStatus == 'ONLINE') {
          print('🔄 Dashboard: Syncing status -> ONLINE');
          ref.read(driverStatusNotifierProvider.notifier).online();
        } else {
          print('🔄 Dashboard: Syncing status -> OFFLINE');
          ref.read(driverStatusNotifierProvider.notifier).offline();
        }

        state = AppState.success(data);
      },
    );
  }
}
