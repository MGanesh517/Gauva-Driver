import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/state/app_state.dart';
import '../../../core/state/driver_status_state.dart';
import '../../../core/state/on_trip_status.dart';
import '../../../data/models/driver_radius_update_response/driver_radius_update_response.dart';
import '../view_model/driver_status_notifier.dart';
import '../view_model/ontrip_status_notifier.dart';
import 'provider.dart';

final driverStatusNotifierProvider = StateNotifierProvider<DriverStatusNotifier, DriverStatusState>(
    (ref) => DriverStatusNotifier(ref, ref.read(statusRepoProvider), ));

final ontripStatusNotifier =
    StateNotifierProvider<OnTripStatusNotifier, OnTripStatusState>((ref) => OnTripStatusNotifier(ref));

final driverRadiusNotifierProvider = StateNotifierProvider<DriverRadiusNotifier, AppState<DriverRadiusUpdateResponse>>(
    (ref) => DriverRadiusNotifier(ref, ref.read(statusRepoProvider)));
