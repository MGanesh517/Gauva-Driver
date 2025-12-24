import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gauva_driver/common/loading_view.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/routes/app_routes.dart';
import 'package:gauva_driver/core/utils/is_dark_mode.dart';
import 'package:gauva_driver/core/utils/localize.dart';
import 'package:gauva_driver/data/services/navigation_service.dart';

import '../../gen/assets.gen.dart';

class LocationPermissionWrapper extends StatefulWidget {
  final Widget child;
  final String? pageName;

  const LocationPermissionWrapper({super.key, required this.child, this.pageName});

  @override
  State<LocationPermissionWrapper> createState() => _LocationPermissionWrapperState();
}

class _LocationPermissionWrapperState extends State<LocationPermissionWrapper> with WidgetsBindingObserver {
  bool _hasPermission = false;
  bool _checked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checked = false;
      _checkPermission();
    }
  }

  Future<void> _checkPermission() async {
    final status = await Geolocator.checkPermission();
    setState(() {
      _hasPermission = status == LocationPermission.always || status == LocationPermission.whileInUse;
      _checked = true;
    });
  }

  Future<void> _requestPermission() async {
    // Show Prominent Disclosure Dialog BEFORE requesting permission
    final disclosureAccepted = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(localize(context).prominent_disclosure_title),
        content: Text(localize(context).prominent_disclosure_message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(localize(context).cancel), // Reuse cancel or "Deny"
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(localize(context).agree ?? "Agree"), // Ensure "Agree" exists or use "Allow"
          ),
        ],
      ),
    );

    if (disclosureAccepted != true) return;

    final status = await Geolocator.requestPermission();

    if (status == LocationPermission.always || status == LocationPermission.whileInUse) {
      setState(() {
        NavigationService.pushNamedAndRemoveUntil(widget.pageName ?? AppRoutes.dashboard);
      });
    } else if (status == LocationPermission.denied ||
        status == LocationPermission.deniedForever ||
        status == LocationPermission.unableToDetermine) {
      // Go to app settings, and after comeback _checkPermission() will be triggered via lifecycle
      await openAppSettings();
    } else {
      await openAppSettings();
      setState(() {
        _hasPermission = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_checked) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: LoadingView()),
      );
    }

    if (_hasPermission) {
      return widget.child;
    }

    return _buildPermissionPage();
  }

  Widget _buildPermissionPage() => Scaffold(
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    floatingActionButton: FloatingActionButton.extended(
      backgroundColor: isDarkMode() ? Colors.white10 : Colors.grey.shade200,
      onPressed: _requestPermission,
      label: Text(
        localize(context).grant_permission,
        style: context.bodyMedium?.copyWith(color: isDarkMode() ? Colors.white : Colors.black),
      ),
    ),
    body: SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Assets.lottie.location.lottie(),
              const SizedBox(height: 20),
              Text(
                localize(context).location_permission_needed,
                textAlign: TextAlign.center,
                style: context.bodyMedium?.copyWith(fontSize: 22.sp, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                localize(context).location_permission_msg,
                textAlign: TextAlign.center,
                style: context.bodyMedium?.copyWith(fontSize: 16.sp),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
