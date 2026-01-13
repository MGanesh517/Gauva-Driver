import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gauva_driver/gen/assets.gen.dart';
import 'package:gauva_driver/presentation/home_page/provider/notification_providers.dart';
import 'package:gauva_driver/presentation/home_page/widgets/online_offline_switch.dart';
import 'package:gauva_driver/presentation/notifications/view/notifications_screen.dart';

Widget topBarOnlineOffline(BuildContext context) => Consumer(
  builder: (context, ref, _) => Row(
    children: [
      Image.asset(Assets.images.appLogo.path, height: 65.h, width: 65.w, fit: BoxFit.fill),
      const Spacer(),
      // Notification icon with badge
    
      SizedBox(width: 8.w),
      onlineOfflineSwitch(context),
    ],
  ),
);

class _NotificationIcon extends ConsumerWidget {
  const _NotificationIcon();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCountState = ref.watch(unreadCountNotifierProvider);
    final unreadCount = unreadCountState.maybeWhen(success: (count) => count, orElse: () => 0);

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen())).then((_) {
          // Refresh unread count when returning from notifications screen
          ref.read(unreadCountNotifierProvider.notifier).refresh();
        });
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
            child: Icon(Icons.notifications_outlined, size: 24.sp, color: Colors.black87),
          ),
          if (unreadCount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                constraints: BoxConstraints(minWidth: 18.w, minHeight: 18.h),
                child: Center(
                  child: Text(
                    unreadCount > 99 ? '99+' : '$unreadCount',
                    style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
