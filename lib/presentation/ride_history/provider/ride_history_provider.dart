import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gauva_driver/core/state/app_state.dart';

import '../../../data/models/order_response/order_model/order/order.dart';
import '../../../data/repositories/interfaces/ride_history_repo_interface.dart';
import '../../../data/repositories/ride_history_repo_impl.dart';
import '../../../data/services/ride_history_service.dart';
import '../../../domain/interfaces/ride_history_service_interface.dart';
import '../../auth/provider/auth_providers.dart';
import '../view_model/ride_history_notifier.dart';

// RideService Provider (depends on Dio)
final rideHistoryServiceProvider = Provider<IRideHistoryService>(
  (ref) => RideHistoryService(dioClient: ref.read(dioClientProvider)),
);

// RideRepo Provider (depends on RideService)
final rideHistoryRepoProvider = Provider<IRideHistoryRepo>(
  (ref) => RideHistoryRepoImpl(rideHistoryService: ref.read(rideHistoryServiceProvider)),
);

final rideHistoryProvider = StateNotifierProvider<RideHistoryNotifier, AppState<List<Order>>>(
  (ref) => RideHistoryNotifier(ref, ref.read(rideHistoryRepoProvider)),
);
