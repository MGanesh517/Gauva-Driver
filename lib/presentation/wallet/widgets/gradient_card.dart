import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/gen/assets.gen.dart';

Widget gradientCard(BuildContext context, {bool isReceived = true, String? value, required String title}) => Expanded(
  child: Container(
    padding: EdgeInsets.all(8.r),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(8.r)),
      gradient: LinearGradient(
        end: Alignment.topRight,
        colors: [
          const Color(0xFF4F4A9F).withValues(alpha: 0.5), // First color (dominant)
          const Color(0xFF4F4A9F).withValues(alpha: 0.5), // First color (dominant)
          const Color(0xFF3690B1).withValues(alpha: 0.2),
        ],
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '₹' + (value ?? ''),
                style: context.bodyMedium?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: isReceived ? const Color(0xFF36B37E) : const Color(0xFFEB5837),
                ),
              ),
            ),
            isReceived
                ? Assets.images.dollarSendCircle.image(height: 20.h, width: 20.w, fit: BoxFit.fill)
                : Assets.images.moneyWithdrawal.image(height: 20.h, width: 20.w, fit: BoxFit.fill),
          ],
        ),
        Gap(8.h),
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.bodyMedium?.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w400, color: Colors.white),
        ),
      ],
    ),
  ),
);
