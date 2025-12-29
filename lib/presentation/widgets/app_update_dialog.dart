import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateDialog extends StatelessWidget {
  final String currentVersion;
  final String latestVersion;
  final String releaseNotes;
  final String appStoreLink;

  const AppUpdateDialog({
    super.key,
    required this.currentVersion,
    required this.latestVersion,
    required this.releaseNotes,
    required this.appStoreLink,
  });

  Future<void> _launchPlayStore() async {
    final Uri uri = Uri.parse(appStoreLink);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        print('❌ Cannot launch Play Store URL: $appStoreLink');
      }
    } catch (e) {
      print('❌ Error launching Play Store: $e');
    }
  }

  @override
  Widget build(BuildContext context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Update Icon
            Icon(Icons.system_update, size: 64.r, color: const Color(0xFF1469B5)),
            Gap(16.h),

            // Title
            Text(
              'Update Available',
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: const Color(0xFF24262D)),
            ),
            Gap(8.h),

            // Version Info
            Text(
              'Version $latestVersion is now available',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color(0xFF687387)),
            ),
            Text(
              'Current version: $currentVersion',
              style: TextStyle(fontSize: 12.sp, color: const Color(0xFF687387)),
            ),
            Gap(16.h),

            // Release Notes
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(color: const Color(0xFFF1F7FE), borderRadius: BorderRadius.circular(8.r)),
              child: Text(
                releaseNotes,
                style: TextStyle(fontSize: 13.sp, color: const Color(0xFF24262D)),
                textAlign: TextAlign.center,
              ),
            ),
            Gap(24.h),

            // Buttons
            Row(
              children: [
                // Later Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      side: const BorderSide(color: Color(0xFF1469B5)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                    child: Text(
                      'Later',
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: const Color(0xFF1469B5)),
                    ),
                  ),
                ),
                Gap(12.w),

                // Update Now Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _launchPlayStore();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      backgroundColor: const Color(0xFF1469B5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                    child: Text(
                      'Update Now',
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
}
