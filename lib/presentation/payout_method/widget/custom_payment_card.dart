import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/utils/localize.dart';
import 'package:gauva_driver/gen/assets.gen.dart';
import 'package:gauva_driver/presentation/payout_method/widget/pay_info.dart';

import '../../wallet/provider/provider.dart';

Widget customPaymentCard(
  BuildContext context,
  WidgetRef ref, {
  String? paymentMethodName,
  String? cardNumber,
  String? cardHolderName,
  String? expiryDate,
  String? id,
}) {
  final deleteState = ref.watch(deleteCardProvider);
  final deleteNotifier = ref.read(deleteCardProvider.notifier);

  final isDeleting = deleteState.maybeWhen(loading: () => deleteNotifier.deletingCardId == id, orElse: () => false);
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(vertical: 16.w, horizontal: 16.w),

    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16.r),
      image: DecorationImage(image: Assets.images.card.provider(), fit: BoxFit.fill),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Assets.images.chip.image(height: 24.h, width: 32.w, fit: BoxFit.fill),
              Expanded(
                child: Text(
                  paymentMethodName ?? '',
                  textAlign: TextAlign.end,
                  style: context.bodyMedium?.copyWith(fontSize: 24.sp, color: Colors.white, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Gap(60.h),
          Text(
            cardNumber ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.bodyMedium?.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          Gap(16.h),
          Row(
            children: [
              payInfo(context, title: localize(context).payment_withdraw, value: cardHolderName),
              payInfo(context, title: localize(context).expiryDate, value: expiryDate),
              InkWell(
                onTap: isDeleting
                    ? null
                    : () {
                        if (id == null) {
                          return;
                        }
                        ref.read(deleteCardProvider.notifier).deleteCard(id: id);
                      },
                child: Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), color: Colors.white),
                  child: isDeleting
                      ? SizedBox(
                          height: 15.h,
                          width: 15.w,
                          child: const Center(child: CircularProgressIndicator()),
                        )
                      : Assets.images.trash.image(height: 18.h, width: 18.w, fit: BoxFit.fill),
                ),
              ),
            ],
          ),
          Gap(8.h),
        ],
      ),
    ),
  );
}
