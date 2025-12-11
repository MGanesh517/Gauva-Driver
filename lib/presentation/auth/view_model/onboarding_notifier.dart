import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingNotifier extends StateNotifier<int> {
  OnboardingNotifier() : super(0);

  void next() => state = state + 1;

  void previous() => state = state - 1;

  void skip() => state = 2;

  void reset() => state = 0;
}
