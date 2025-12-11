import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/utils/localize.dart';
import 'package:gauva_driver/data/services/navigation_service.dart';

import '../../../core/utils/is_dark_mode.dart';
import '../../../gen/assets.gen.dart';

Future<void> showAutoDismissDialog() async {
  final navigator = NavigationService.navigatorKey.currentState;

  navigator?.push(
    PageRouteBuilder(
      opaque: false,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      pageBuilder: (context, animation, secondaryAnimation) {
        // Auto dismiss after 2 seconds without using context
        Future.delayed(const Duration(seconds: 2), () {
          if (navigator.canPop()) {
            navigator.pop();
          }
        });

        return Center(
          child: FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(
                begin: 0.8,
                end: 1.0,
              ).animate(CurvedAnimation(parent: animation, curve: Curves.elasticOut)),
              child: AlertDialog(
                backgroundColor: context.surface,
                contentPadding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Assets.images.successRound.image(height: 60.h, width: 60.w),
                    Gap(24.h),
                    Text(
                      localize(context).issueSubmitted,
                      textAlign: TextAlign.center,
                      style: context.bodyMedium?.copyWith(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        color: isDarkMode() ? const Color(0xFF687387) : const Color(0xFF24262D),
                      ),
                    ),
                    Gap(8.h),
                    Text(
                      localize(context).thanksForReporting,
                      textAlign: TextAlign.center,
                      style: context.bodyMedium?.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF687387),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}
