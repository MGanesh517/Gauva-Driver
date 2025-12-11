import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/utils/localize.dart';

import '../../../core/theme/color_palette.dart';
import '../../../core/widgets/buttons/app_primary_button.dart';
import '../../data/services/navigation_service.dart';
import '../../gen/assets.gen.dart';
import '../../presentation/auth/provider/auth_providers.dart';
import '../../presentation/booking/provider/driver_providers.dart';
import '../../presentation/booking/provider/pusher_provider.dart';

class ExitAppWrapper extends StatelessWidget {
  final Widget child;
  const ExitAppWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    onPopInvokedWithResult: (v, d) async {
      if (!v) {
        await showExitLogoutDialogue(isLogout: false);
      }
    },
    child: GestureDetector(
      child: child,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
    ),
  );
}

class ExitLogOut extends StatelessWidget {
  final Function() onAllow;
  final Function() onCancel;
  final bool isLogout;

  const ExitLogOut({super.key, required this.onAllow, required this.isLogout, required this.onCancel});

  @override
  Widget build(BuildContext context) => AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    contentPadding: EdgeInsets.zero,
    content: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min, // <- This makes dialog wrap content
          children: [
            Assets.images.exitLogo.image(height: 60.h, width: 60.w, fit: BoxFit.contain),
            Gap(16.h),
            Text(
              localize(context).are_you_sure_msg(isLogout ? localize(context).log_out : localize(context).exit),
              style: context.headlineSmall?.copyWith(fontSize: 24.sp),
              textAlign: TextAlign.center,
            ),
            Gap(8.h),
            Text(
              localize(context).see_you_next_ride,
              style: context.headlineSmall?.copyWith(
                color: const Color(0xFF687387),
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
              ),
              textAlign: TextAlign.center,
            ),
            Gap(24.h),
            Row(
              children: [
                Expanded(
                  child: AppPrimaryButton(
                    backgroundColor: ColorPalette.neutral100,
                    onPressed: onAllow,
                    child: Text(
                      isLogout ? localize(context).log_out : localize(context).exit,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: ColorPalette.primary50,
                      ),
                    ),
                  ),
                ),
                Gap(16.w),
                Expanded(
                  child: AppPrimaryButton(
                    backgroundColor: const Color(0xFFEB5A3C),
                    showBorder: false,
                    onPressed: onCancel,
                    child: Text(
                      localize(context).cancel,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: ColorPalette.neutral100,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Future<bool> showExitLogoutDialogue({WidgetRef? ref, required bool isLogout}) async {
  final context = NavigationService.navigatorKey.currentContext!;

  final bool? shouldExit = await showDialog<bool>(
    context: context,
    builder: (_) => ExitLogOut(
      onCancel: () {
        Navigator.of(context).pop(false);
      },
      onAllow: () async {
        if (isLogout) {
          await ref?.read(logoutNotifierProvider.notifier).logout();
        } else {
          ref?.read(pusherNotifierProvider.notifier).disconnect();
          ref?.read(driverStatusNotifierProvider.notifier).updateOnlineStatus('offline');
          SystemNavigator.pop();
        }
      },
      isLogout: isLogout,
    ),
  );
  return shouldExit ?? false;
}
