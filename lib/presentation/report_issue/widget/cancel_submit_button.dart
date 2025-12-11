import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/utils/helpers.dart';
import 'package:gauva_driver/core/utils/is_dark_mode.dart';
import 'package:gauva_driver/core/utils/localize.dart';
import 'package:gauva_driver/core/widgets/buttons/app_primary_button.dart';
import 'package:gauva_driver/data/services/navigation_service.dart';
import 'package:gauva_driver/presentation/report_issue/provider/report_provider.dart';

Widget cancelSubmitButton(
  BuildContext context, {
  required int? orderId,
  required TextEditingController details,
  required String? reportType,
}) => Container(
  color: context.surface,
  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
  child: Row(
    children: [
      Expanded(
        child: AppPrimaryButton(
          showBorder: isDarkMode(),
          backgroundColor: const Color(0xFFF6F7F9),
          onPressed: () {
            NavigationService.pop();
          },
          child: Text(
            localize(context).cancel,
            style: context.bodyMedium?.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: isDarkMode() ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
      Gap(16.w),
      Consumer(
        builder: (context, ref, _) {
          final submitState = ref.watch(reportSubmitNotifierProvider);
          final submitStateNotifier = ref.watch(reportSubmitNotifierProvider.notifier);
          return Expanded(
            child: AppPrimaryButton(
              isDisabled: submitState.whenOrNull(loading: () => true) ?? false,
              isLoading: submitState.whenOrNull(loading: () => true) ?? false,
              onPressed: () {
                if (orderId == null || details.text.trim().isEmpty || reportType == null) {
                  showNotification(message: localize(context).insertAllData);
                } else {
                  submitStateNotifier.submitReport(orderId: orderId, details: details.text, reportName: reportType);
                }
              },
              child: Text(
                localize(context).submit,
                style: context.bodyMedium?.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.white),
              ),
            ),
          );
        },
      ),
    ],
  ),
);
