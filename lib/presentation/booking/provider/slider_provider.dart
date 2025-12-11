import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gauva_driver/presentation/booking/provider/ride_providers.dart';

import '../../../core/state/app_state.dart';
import '../../../data/models/order_response/order_model/order/order.dart';
import '../view_model/slider_button_notifier.dart';

final sliderButtonNotifierProvider = StateNotifierProvider<SliderButtonNotifier, AppState<Order>>(
  (ref) => SliderButtonNotifier(ref: ref, rideRepo: ref.read(rideRepoProvider)),
);
