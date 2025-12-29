import 'package:flutter/material.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:gauva_driver/presentation/widgets/app_update_dialog.dart';

class VersionCheckService {
  static Future<void> checkForUpdate(BuildContext context) async {
    try {
      final newVersionPlus = NewVersionPlus(
        androidId: 'com.gauva.driverapp', // Your actual package name
      );

      final status = await newVersionPlus.getVersionStatus();

      if (status != null && status.canUpdate) {
        if (context.mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AppUpdateDialog(
                currentVersion: status.localVersion,
                latestVersion: status.storeVersion,
                releaseNotes: status.releaseNotes ?? 'A new version is available with improvements and bug fixes.',
                appStoreLink: status.appStoreLink,
              );
            },
          );
        }
      }
    } catch (e) {
      print('⚠️ Error checking for app update: $e');
      // Silently fail - don't show error to user
    }
  }
}
