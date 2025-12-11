import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/ride_history/ride_history_state.dart';
import '../view_model/ride_detail_history_notifier.dart';

final rideDetailHistoryProvider = StateNotifierProvider<RideDetailHistoryNotifier, RideHistoryState>((ref) => RideDetailHistoryNotifier(ref));
