import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/state/app_state.dart';
import '../../../data/models/car_color_response/car_color_response.dart';
import '../../../data/models/car_model_response/car_model_response.dart';
import '../view_model/car_info_notifier.dart';
import 'app_config_providers.dart';

final carModelNotifierProvider = StateNotifierProvider.autoDispose<CarModelNotifier, AppState<CarModelResponse>>(
    (ref) => CarModelNotifier(ref.read(configRepoProvider)));

final carColorNotifierProvider = StateNotifierProvider.autoDispose<CarColorNotifier, AppState<CarColorResponse>>(
    (ref) => CarColorNotifier(ref.read(configRepoProvider)));
