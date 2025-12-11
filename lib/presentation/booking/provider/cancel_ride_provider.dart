import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gauva_driver/data/models/common_response.dart';

import '../../../core/state/app_state.dart';
import '../../../data/repositories/cancel_ride_repo_impl.dart';
import '../../../data/repositories/interfaces/cancel_ride_repo_interface.dart';
import '../../../data/services/cancel_ride_service.dart';
import '../../../domain/interfaces/cancel_ride_service_interface.dart';
import '../../auth/provider/auth_providers.dart';
import '../view_model/cancel_ride_notifier.dart';

// RideService Provider (depends on Dio)
final cancelRideServiceProvider = Provider<ICancelRideService>(
  (ref) => CancelRideService(dioClient: ref.read(dioClientChattingProvider)),
);

// RideRepo Provider (depends on RideService)
final cancelRideRepoProvider = Provider<ICancelRideRepo>(
  (ref) => CancelRideRepoImpl(rideService: ref.read(cancelRideServiceProvider)),
);

// AcceptRide ViewModel Provider (autoDispose)
final cancelRideNotifierProvider = StateNotifierProvider<CancelRideNotifier, AppState<CommonResponse>>(
  (ref) => CancelRideNotifier(ref, ref.read(cancelRideRepoProvider)),
);
