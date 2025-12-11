import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Create a Notifier that holds a boolean state
class LoadingNotifier extends Notifier<bool> {
  @override
  bool build() {
    // Initial state is false → not loading
    return false;
  }

  // Start loading
  void startLoading() {
    state = true;
  }

  // Stop loading
  void stopLoading() {
    state = false;
  }

  // Optional: toggle loading
  void toggleLoading() {
    state = !state;
  }
}

// 2. Create a Riverpod provider for the notifier
final loadingProvider = NotifierProvider<LoadingNotifier, bool>(
      () => LoadingNotifier(),
);
