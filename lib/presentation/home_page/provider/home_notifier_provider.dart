import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gauva_driver/core/state/app_state.dart';
import 'package:gauva_driver/data/models/dashboard_model/dashboard_model.dart';
import 'package:gauva_driver/data/repositories/dashboard_repo_impl.dart';
import 'package:gauva_driver/data/repositories/interfaces/dashboard_repo_interface.dart';
import 'package:gauva_driver/domain/interfaces/dashboard_service_interface.dart';

import '../../../data/services/dashboard_service.dart';
import '../../auth/provider/auth_providers.dart';
import '../view_model/home_notifier.dart';

final dashboardServiceProvider = Provider<IDashboardService>(
  (ref) => DashboardServiceImpl(dioClient: ref.read(dioClientProvider)),
);

// RideRepo Provider (depends on RideService)
final dashboardRepoProvider = Provider<IDashboardRepository>(
  (ref) => DashboardRepoImpl(dashboardService: ref.read(dashboardServiceProvider)),
);

final homeProvider = StateNotifierProvider<HomeNotifier, AppState<DashboardData?>>(
  (ref) => HomeNotifier(ref, ref.read(dashboardRepoProvider)),
);
