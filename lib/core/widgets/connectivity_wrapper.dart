import 'package:flutter/material.dart';
import 'package:gauva_driver/core/utils/connectivity_monitor.dart';
import 'package:gauva_driver/core/routes/app_routes.dart';
import 'package:gauva_driver/core/utils/helpers.dart';
import 'package:gauva_driver/data/services/navigation_service.dart';

class GlobalConnectivityWrapper extends StatefulWidget {
  final Widget child;
  const GlobalConnectivityWrapper({super.key, required this.child});

  @override
  State<GlobalConnectivityWrapper> createState() => _GlobalConnectivityWrapperState();
}

class _GlobalConnectivityWrapperState extends State<GlobalConnectivityWrapper> {
  final ConnectivityMonitor _monitor = ConnectivityMonitor();
  bool isConnected = true;
  bool _isOnNoInternetPage = false;

  @override
  void initState() {
    super.initState();
    _monitor.onStatusChange.listen((connected) {
      if (!connected && !_isOnNoInternetPage) {
        _isOnNoInternetPage = true;
        showNotification(message: 'No Internet! Please connect to internet');
        Future.delayed(const Duration(microseconds: 300)).then((_) {
          NavigationService.pushNamedAndRemoveUntil(AppRoutes.noInternet);
        });
      } else if (connected && _isOnNoInternetPage) {
        _isOnNoInternetPage = false;
        showNotification(message: 'Your Internet connection restored', isSuccess: true);
        Future.delayed(const Duration(microseconds: 300)).then((_) {
          NavigationService.pushNamedAndRemoveUntil(AppRoutes.splash);
        });
      }
      isConnected = connected;
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void dispose() {
    _monitor.dispose();
    super.dispose();
  }
}
