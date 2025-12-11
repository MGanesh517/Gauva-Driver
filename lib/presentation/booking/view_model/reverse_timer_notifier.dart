import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gauva_driver/data/services/navigation_service.dart';

final reverseTimerProvider = NotifierProvider<ReverseTimerNotifier, int>(ReverseTimerNotifier.new);

class ReverseTimerNotifier extends Notifier<int> {
  Timer? _timer;
  final int _startTime = 30;

  @override
  int build() {
    // When the Notifier is disposed, cancel the timer
    ref.onDispose(() {
      _timer?.cancel();
    });

    return _startTime;
  }

  void startTimer() {
    resetTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      debugPrint('remaining time: $state');
      if (state > 0) {
        state--;
      } else {
        stopTimer();
        NavigationService.pop();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void resetTimer() {
    stopTimer();
    state = _startTime;
  }

  bool get isRunning => _timer?.isActive ?? false;
  int get totalTime => _startTime;
}
