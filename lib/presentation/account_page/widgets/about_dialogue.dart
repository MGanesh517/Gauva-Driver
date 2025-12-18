import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gauva_driver/common/loading_view.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/utils/localize.dart';
import 'package:gauva_driver/core/widgets/error_view.dart';
import 'package:gauva_driver/presentation/account_page/provider/terms_and_privacy_provider.dart';

import '../../../core/theme/color_palette.dart';
import '../../../core/utils/is_dark_mode.dart';
import '../../../data/services/navigation_service.dart';
import '../../../gen/assets.gen.dart';

Future<void> termsAndConditionDialogue(BuildContext context, {bool showTermsAndCondition = true}) async {
  final platformInfo = await PackageInfo.fromPlatform();

  if (context.mounted) {
    _showTermsDialog(context, platformInfo, showTermsAndCondition);
  }
}

void _showTermsDialog(BuildContext context, PackageInfo platformInfo, bool showTermsAndCondition) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: isDarkMode() ? const BorderSide(color: Colors.white) : BorderSide.none,
      ),
      backgroundColor: isDarkMode() ? Colors.black : Colors.white,
      contentPadding: EdgeInsets.all(16.w),
      titlePadding: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
      title: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Assets.images.rideInHome.image(width: 150.w, height: 150.h),
          ),
          Gap(6.h),
          Text(
            platformInfo.appName,
            textAlign: TextAlign.center,
            style: context.bodyMedium?.copyWith(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: ColorPalette.primary50,
            ),
          ),
          // Gap(4.h),
          // Text(
          //   'Version: ${platformInfo.version} (Build ${platformInfo.buildNumber})',
          //   style: context.bodySmall?.copyWith(fontSize: 12.sp, color: Colors.grey),
          // ),
        ],
      ),
      content: Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(termsAndConditionProvider);
          final policyState = ref.watch(privacyAndPolicyProvider);

          return SizedBox(
            height: 300.h,
            child: Column(
              children: [
                Gap(8.h),
                Text(
                  showTermsAndCondition ? localize(context).terms_conditions : localize(context).privacy_policy,
                  style: context.bodyMedium?.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode() ? Colors.white : Colors.black87,
                    decoration: TextDecoration.underline,
                    decorationColor: isDarkMode() ? Colors.white : Colors.black87,
                    decorationThickness: 1.5,
                  ),
                ),
                Gap(8.h),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        showTermsAndCondition
                            ? state.when(
                                initial: () => const SizedBox.shrink(),
                                loading: () => const LoadingView(),
                                success: (data) => Text(
                                  data.data?.terms ?? 'N/A',
                                  style: context.bodySmall?.copyWith(
                                    fontSize: 14.sp,
                                    color: isDarkMode() ? Colors.white : Colors.black87,
                                  ),
                                ),
                                error: (e) => ErrorView(message: e.message),
                              )
                            : policyState.when(
                                initial: () => const SizedBox.shrink(),
                                loading: () => const LoadingView(),
                                success: (data) => Text(
                                  data.data?.policy ?? 'N/A',
                                  style: context.bodySmall?.copyWith(
                                    fontSize: 14.sp,
                                    color: isDarkMode() ? Colors.white : Colors.black87,
                                  ),
                                ),
                                error: (e) => ErrorView(message: e.message),
                              ),
                      ],
                    ),
                  ),
                ),
                // Gap(16.h),
                // Center(
                //   child: Text(
                //     localize(context).all_rights_reserved('© 2025 Gauva.'),
                //     textAlign: TextAlign.center,
                //     style: context.bodySmall?.copyWith(fontSize: 12.sp, color: ColorPalette.primary50),
                //   ),
                // ),
              ],
            ),
          );
        },
      ),
      actionsPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => NavigationService.pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDarkMode() ? context.surface : ColorPalette.primary50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
              padding: EdgeInsets.symmetric(vertical: 12.h),
            ),
            child: Text(
              localize(context).close,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.white),
            ),
          ),
        ),
      ],
    ),
  );
}
