import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/utils/localize.dart';
import 'package:gauva_driver/presentation/account_page/provider/delete_account_provider.dart';

import '../../data/services/navigation_service.dart';
import '../../gen/assets.gen.dart';

import '../theme/color_palette.dart';
import '../widgets/buttons/app_primary_button.dart';

class DeleteAccountDialog extends StatelessWidget {
  const DeleteAccountDialog({super.key});

  @override
  Widget build(BuildContext context) => AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    contentPadding: EdgeInsets.zero,
    content: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), color: const Color(0xFFFFE5DF)),
              child: Assets.images.trash.image(height: 40.h, width: 40.w, fit: BoxFit.contain),
            ),
            Gap(16.h),
            Text(
              localize(context).delete_account_confirmation,
              style: context.headlineSmall?.copyWith(fontSize: 24.sp),
              textAlign: TextAlign.center,
            ),
            Gap(8.h),
            Text(
              localize(context).delete_account_warning,
              style: context.headlineSmall?.copyWith(
                color: const Color(0xFF687387),
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
              ),
              textAlign: TextAlign.center,
            ),
            Gap(24.h),
            Consumer(
              builder: (context, ref, _) {
                final notifier = ref.read(deleteAccountProvider.notifier);
                final state = ref.watch(deleteAccountProvider);
                final bool isLoading = state.whenOrNull(loading: () => true) ?? false;
                return Row(
                  children: [
                    Expanded(
                      child: AppPrimaryButton(
                        isDisabled: isLoading,
                        isLoading: isLoading,
                        backgroundColor: ColorPalette.neutral100,
                        onPressed: () {
                          notifier.deleteAccount();
                        },
                        child: Text(
                          localize(context).delete,
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
                        isDisabled: isLoading,
                        isLoading: isLoading,
                        backgroundColor: const Color(0xFFEB5A3C),
                        showBorder: false,
                        onPressed: () {
                          Navigator.pop(context);
                        },
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
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}

void showDeleteAccountDialog() {
  final context = NavigationService.navigatorKey.currentContext!;

  showDialog(context: context, builder: (_) => const DeleteAccountDialog());
}
