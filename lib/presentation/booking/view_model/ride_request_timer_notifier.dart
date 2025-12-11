import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CancelButtonTimerState {
  final int remainingSeconds;
  final bool isButtonEnabled;

  CancelButtonTimerState({
    required this.remainingSeconds,
    required this.isButtonEnabled,
  });

  CancelButtonTimerState copyWith({
    int? remainingSeconds,
    bool? isButtonEnabled,
  }) =>
      CancelButtonTimerState(
        remainingSeconds: remainingSeconds ?? this.remainingSeconds,
        isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
      );
}

class CancelButtonEnableTimerNotifier
    extends StateNotifier<CancelButtonTimerState> {
  final Ref ref;
  Timer? _timer;
  final _storage = const FlutterSecureStorage();

  static const int _initialDuration = 300; // 5 minutes
  static const String _key = 'cancel_button_timer_end';

  CancelButtonEnableTimerNotifier(this.ref)
      : super(CancelButtonTimerState(
    remainingSeconds: 0,
    isButtonEnabled: false,
  )) {
    _loadTimer();
  }

  Future<void> _loadTimer() async {
    final endTimeStr = await _storage.read(key: _key);

    int remaining = 0;

    if (endTimeStr != null) {
      final endTimeMillis = int.tryParse(endTimeStr);
      if (endTimeMillis != null) {
        remaining =
            ((endTimeMillis - DateTime.now().millisecondsSinceEpoch) / 1000)
                .ceil();
      }
    }

    if (remaining > 0) {
      state = state.copyWith(
        remainingSeconds: remaining,
        isButtonEnabled: false,
      );
      _startCountdown();
    } else {
      state = state.copyWith(
        remainingSeconds: 0,
        isButtonEnabled: true, // ✅ button always enabled if timer expired
      );
      await _storage.delete(key: _key);
    }
  }


  Future<void> startTimer() async {
    _timer?.cancel();
    state = state.copyWith(
      remainingSeconds: _initialDuration,
      isButtonEnabled: false,
    );

    final endTimeMillis =
        DateTime.now().millisecondsSinceEpoch + (_initialDuration * 1000);
    await _storage.write(key: _key, value: endTimeMillis.toString());

    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final current = state.remainingSeconds;
      debugPrint('$current');
      if (current > 1) {
        state = state.copyWith(remainingSeconds: current - 1);
      } else {
        timer.cancel();
        state = state.copyWith(
          remainingSeconds: 0,
          isButtonEnabled: true,
        );
        await _storage.delete(key: _key);
      }
    });
  }

  Future<void> cancelTimer() async {
    _timer?.cancel();
    state = state.copyWith(
      remainingSeconds: 0,
      isButtonEnabled: false,
    );
    await _storage.delete(key: _key);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
