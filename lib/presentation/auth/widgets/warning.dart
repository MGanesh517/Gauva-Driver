import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/utils/is_dark_mode.dart';
import 'package:gauva_driver/core/utils/localize.dart';
import 'package:gauva_driver/core/widgets/buttons/app_primary_button.dart';
import 'package:gauva_driver/data/services/navigation_service.dart';
import 'package:gauva_driver/gen/assets.gen.dart';

Future<bool?> showWarning() async {
  final result = await showDialog<bool>(
    context: NavigationService.navigatorKey.currentContext!,
    barrierDismissible: false,
    builder: (context) => Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r), color: context.surface),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Assets.images.person.image(height: 80.h, width: 80.w),
            Gap(29.h),
            Text(
              localize(context).loggingInSomewhereElse,
              textAlign: TextAlign.center,
              style: context.bodyMedium?.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: isDarkMode() ? Colors.white70 : const Color(0xFF24262D),
              ),
            ),
            Gap(8.h),
            Text(
              localize(context).yourAccountAlreadyActive,
              textAlign: TextAlign.center,
              style: context.bodyMedium?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF687387),
              ),
            ),
            Gap(24.w),
            Row(
              children: [
                Expanded(
                  child: AppPrimaryButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    showBorder: false,
                    backgroundColor: isDarkMode() ? context.surface : const Color(0xFFF6F7F9),
                    child: Text(
                      localize(context).cancel,
                      style: context.bodyMedium?.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode() ? Colors.white70 : const Color(0xFF24262D),
                      ),
                    ),
                  ),
                ),
                Gap(16.w),
                Expanded(
                  child: AppPrimaryButton(
                    onPressed: () async {
                      Navigator.of(context).pop(true);
                    },
                    child: Text(
                      localize(context).stayOnThisDevice,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.bodyMedium?.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
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

  return result; // true or false (or null if dismissed)
}
