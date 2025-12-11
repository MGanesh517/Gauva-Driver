import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view_model/ride_request_timer_notifier.dart';

final cancelButtonEnableTimerProvider =
StateNotifierProvider<CancelButtonEnableTimerNotifier, CancelButtonTimerState>(
      (ref) => CancelButtonEnableTimerNotifier(ref),
);
