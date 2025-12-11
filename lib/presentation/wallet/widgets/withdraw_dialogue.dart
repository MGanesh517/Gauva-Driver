import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/utils/helpers.dart';
import 'package:gauva_driver/core/utils/is_dark_mode.dart';
import 'package:gauva_driver/core/utils/localize.dart';
import 'package:gauva_driver/core/widgets/buttons/app_primary_button.dart';
import 'package:gauva_driver/data/services/navigation_service.dart';
import 'package:gauva_driver/gen/assets.gen.dart';
import 'package:gauva_driver/presentation/payment_method/provider/provider.dart';
import 'package:gauva_driver/presentation/payment_method/widgets/payment_method_dropwodn.dart';
import 'package:gauva_driver/presentation/wallet/provider/provider.dart';

import '../../../core/theme/color_palette.dart';
import '../../auth/widgets/text_field_with_title.dart';

Future<void> showWithdrawDialog(BuildContext context) =>
    showDialog(context: context, builder: (_) => const WithdrawDialog());

class WithdrawDialog extends StatefulWidget {
  const WithdrawDialog({super.key});

  @override
  State<WithdrawDialog> createState() => _WithdrawDialogState();
}

class _WithdrawDialogState extends State<WithdrawDialog> {
  final TextEditingController _amountController = TextEditingController(text: '200');
  String selectedMethod = 'Stripe';

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: context.surface,
    insetPadding: EdgeInsets.all(16.r),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
    child: Container(
      padding: EdgeInsets.all(16.r),
      width: 320.w,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Assets.images.withdrawEarning.image(height: 60.h, width: 60.w, fit: BoxFit.fill), // Replace with your asset
            Gap(16.h),
            Text(
              localize(context).withdraw_your_earnings,
              textAlign: TextAlign.center,
              style: context.bodyMedium?.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: isDarkMode() ? const Color(0xFF687387) : const Color(0xFF24262D),
              ),
            ),
            Gap(8.h),
            Text(
              localize(context).withdraw_instruction,
              textAlign: TextAlign.center,
              style: context.bodyMedium?.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF687387),
              ),
            ),
            Gap(16.h),
            paymentMethodDropdown(context),
            Gap(16.h),
            TextField(
              controller: _amountController,
              style: context.bodyMedium?.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: isDarkMode() ? Colors.white : const Color(0xFF24262D),
              ),
              decoration: InputDecoration(
                hintText: localize(context).enter_amount,
                border: border(),
                enabledBorder: border(),
                focusedBorder: border(true),
                contentPadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
              ),
              keyboardType: TextInputType.number,
            ),
            Gap(24.h),
            Row(
              children: [
                Expanded(
                  child: AppPrimaryButton(
                    backgroundColor: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      localize(context).cancel,
                      style: context.bodyMedium?.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: ColorPalette.primary50,
                      ),
                    ),
                  ),
                ),
                Gap(16.w),
                Consumer(
                  builder: (context, ref, _) {
                    final state = ref.watch(withdrawProvider);
                    final notifier = ref.watch(withdrawProvider.notifier);
                    return Expanded(
                      child: AppPrimaryButton(
                        isLoading: state.whenOrNull(loading: () => true) ?? false,
                        isDisabled: state.whenOrNull(loading: () => true) ?? false,
                        onPressed: () async {
                          final selected = ref.read(selectedPayMethodProvider);
                          if (selected == null) {
                            showNotification(message: localize(context).please_select_payment_type);
                            return;
                          }
                          if (_amountController.text.trim().isEmpty) {
                            showNotification(message: localize(context).enter_amount);
                            return;
                          }
                          notifier.withdraw(
                            body: {'amount': _amountController.text.trim(), 'method': selected.value?.toLowerCase()},
                            amount: _amountController.text.trim(),
                          );
                        },
                        child: Text(
                          localize(context).withdraw,
                          style: context.bodyMedium?.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  ).animate().scale(duration: 300.ms, curve: Curves.easeOutBack);
}

Future<void> showWithdrawRequestSubmitDialog(BuildContext context, {required String amount}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => withdrawRequestSubmitDialog(context, amount: amount),
  );
  // Wait 2 seconds
  await Future.delayed(const Duration(seconds: 2));
  Navigator.pop(NavigationService.navigatorKey.currentContext!);
}

Widget withdrawRequestSubmitDialog(BuildContext context, {required String amount}) => Dialog(
  backgroundColor: context.surface,
  insetPadding: EdgeInsets.all(16.r),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
  child: Container(
    padding: EdgeInsets.all(16.r),
    width: 320.w,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Assets.images.doneCircle.image(height: 60.h, width: 60.w, fit: BoxFit.fill), // Replace with your asset
        Gap(16.h),
        Text(
          localize(context).withdrawal_success,
          textAlign: TextAlign.center,
          style: context.bodyMedium?.copyWith(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: isDarkMode() ? const Color(0xFF687387) : const Color(0xFF24262D),
          ),
        ),
        Gap(8.h),
        Text(
          localize(context).withdrawal_request_success(amount),
          textAlign: TextAlign.center,
          style: context.bodyMedium?.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF687387),
          ),
        ),
        Gap(16.h),
      ],
    ),
  ),
).animate().scale(duration: 300.ms, curve: Curves.linearToEaseOut);
