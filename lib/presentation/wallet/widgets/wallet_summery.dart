import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/theme/color_palette.dart';
import 'package:gauva_driver/core/utils/localize.dart';
import 'package:gauva_driver/gen/assets.gen.dart';
import 'package:gauva_driver/presentation/wallet/provider/provider.dart';
import 'package:gauva_driver/presentation/wallet/widgets/withdraw_dialogue.dart';

import '../../payment_method/provider/provider.dart';
import 'gradient_card.dart';

Widget walletSummery(BuildContext context) => Consumer(
  builder: (context, ref, _) {
    final balance = ref.watch(walletsBalanceProvider);
    final data = balance.whenOrNull(success: (data) => data.data);
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        image: DecorationImage(image: Assets.images.walletBackground.provider(), fit: BoxFit.fill),
      ),
      child: IntrinsicHeight(
        child: Column(
          children: [
            Row(
              children: [
                gradientCard(
                  context,
                  title: localize(context).payment_received,
                  value: (data?.paymentHistory ?? 0).toString(),
                ),
                Gap(16.w),
                gradientCard(
                  context,
                  title: localize(context).payment_withdraw,
                  value: (data?.paymentWithdraw ?? 0).toString(),
                  isReceived: false,
                ),
              ],
            ),
            Gap(12.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '₹' + (data?.wallet?.toString() ?? ''),
                        textAlign: TextAlign.start,
                        style: context.bodyMedium?.copyWith(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        localize(context).current_balance,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: context.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white60,
                        ),
                      ),
                    ],
                  ),
                ),
                // InkWell(
                //   onTap: () {
                //     ref.read(paymentMethodsNotifierProvider.notifier).getPaymentMethods();
                //     showWithdrawDialog(context);
                //   },
                //   child: Container(
                //     padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), color: ColorPalette.primary50),
                //     child: Text(
                //       localize(context).withdraw,
                //       style: context.bodyMedium?.copyWith(
                //         fontSize: 12.sp,
                //         fontWeight: FontWeight.w500,
                //         color: Colors.white,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  },
);
