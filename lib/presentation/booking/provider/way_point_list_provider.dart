import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gauva_driver/core/state/app_state.dart';
import 'package:gauva_driver/data/models/common_response.dart';
import 'package:gauva_driver/data/models/route_info_model.dart';

import '../../../data/repositories/interfaces/way_points_repo_interface.dart';
import '../../../data/repositories/way_points_repo_impl.dart';
import '../../../data/services/google_api_service.dart';
import '../../../domain/interfaces/google_api_service_interface.dart';
import '../../auth/provider/auth_providers.dart';
import '../view_model/route_notifier.dart';

// Service Provider
final googleApiServiceProvider = Provider<IGoogleApiService>(
  (ref) => GoogleApiService(dioClient: ref.read(dioClientProvider)),
);

// Repo Provider
final googleAPIRepoProvider = Provider<IGoogleAPIRepo>((ref) => GoogleAPIRepoImpl(ref.read(googleApiServiceProvider)));

final routeNotifierProvider = StateNotifierProvider<RouteNotifier, AppState<RouteInfo>>(
  (ref) => RouteNotifier(ref: ref, googleAPIRepo: ref.read(googleAPIRepoProvider)),
);

final sendTravelInfoProvider = StateNotifierProvider<SendTravelInfoNotifier, AppState<CommonResponse>>(
  (ref) => SendTravelInfoNotifier(ref: ref, googleAPIRepo: ref.read(googleAPIRepoProvider)),
);

final routeProgressProvider = StateProvider<double>((ref) => 0.0);
