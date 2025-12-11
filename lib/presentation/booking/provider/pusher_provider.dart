import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view_model/pusher_notifier.dart';

final pusherNotifierProvider = StateNotifierProvider<PusherNotifier, void>(
      (ref) => PusherNotifier(ref),
);
