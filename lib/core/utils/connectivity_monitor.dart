import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityMonitor {
  final _connectivity = Connectivity();
  final StreamController<bool> _statusController = StreamController<bool>.broadcast();

  Stream<bool> get onStatusChange => _statusController.stream;

  ConnectivityMonitor() {
    _connectivity.onConnectivityChanged.listen(_handleChange);
    _init();
  }

  Future<void> _init() async {
    final results = await _connectivity.checkConnectivity();
    _handleChange(results);
  }

  void _handleChange(List<ConnectivityResult> results) {
    final isConnected = results.any((r) => r != ConnectivityResult.none);
    _statusController.add(isConnected);
  }

  void dispose() {
    _statusController.close();
  }
}
