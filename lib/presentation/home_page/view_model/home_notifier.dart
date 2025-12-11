import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gauva_driver/core/state/app_state.dart';
import 'package:gauva_driver/data/models/dashboard_model/dashboard_model.dart';
import 'package:gauva_driver/data/repositories/interfaces/dashboard_repo_interface.dart';

class HomeNotifier extends StateNotifier<AppState<DashboardData?>> {
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
        state = AppState.success(data.data);
      },
    );
  }
}
