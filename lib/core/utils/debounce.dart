import 'dart:async';

/// Debounce utility to delay function execution
/// Useful for search inputs, API calls on user input, etc.
class Debouncer {
  final Duration delay;
  Timer? _timer;
  
  Debouncer({this.delay = const Duration(milliseconds: 500)});
  
  /// Call the function after delay, cancelling previous calls
  void call(void Function() callback) {
    _timer?.cancel();
    _timer = Timer(delay, callback);
  }
  
  /// Cancel pending execution
  void cancel() {
    _timer?.cancel();
  }
  
  /// Dispose the debouncer
  void dispose() {
    _timer?.cancel();
  }
}

/// Debounce for async functions
class AsyncDebouncer {
  final Duration delay;
  Timer? _timer;
  
  AsyncDebouncer({this.delay = const Duration(milliseconds: 500)});
  
  /// Call the async function after delay, cancelling previous calls
  Future<T?> call<T>(Future<T> Function() callback) async {
    _timer?.cancel();
    
    final completer = Completer<T?>();
    
    _timer = Timer(delay, () async {
      try {
        final result = await callback();
        completer.complete(result);
      } catch (e) {
        completer.completeError(e);
      }
    });
    
    return completer.future;
  }
  
  /// Cancel pending execution
  void cancel() {
    _timer?.cancel();
  }
  
  /// Dispose the debouncer
  void dispose() {
    _timer?.cancel();
  }
}
