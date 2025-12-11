import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/utils/is_dark_mode.dart';

import '../../../core/theme/color_palette.dart';
import '../../../core/utils/localize.dart';
import '../../../data/models/order_response/order_model/address/address.dart';
import '../../booking/widgets/icon_destination.dart';

Widget readAbleLocationView(BuildContext context, Addresses? address, {Color? backGroundColor}) => Row(
  children: [
    Expanded(
      child: locationBackground(
        context,
        title: localize(context).pickup,
        subTitle: address?.pickupAddress,
        backGroundColor: backGroundColor,
      ),
    ),
    Gap(8.h),
    Expanded(
      child: locationBackground(
        context,
        title: localize(context).destination,
        subTitle: address?.dropAddress,
        isPickupPoint: false,
        backGroundColor: backGroundColor,
      ),
    ),
  ],
);

Widget getCircleBackground(Widget child) =>
    CircleAvatar(radius: 13.r, backgroundColor: isDarkMode() ? Colors.grey.shade500 : Colors.white, child: child);

Widget locationBackground(
  BuildContext context, {
  bool isPickupPoint = true,
  required String title,
  String? subTitle,
  Color? backGroundColor,
}) => Container(
  width: double.infinity,
  // height: double.infinity,
  constraints: const BoxConstraints(minHeight: 120, maxHeight: 120),
  padding: EdgeInsets.all(12.r),
  decoration: BoxDecoration(
    color: isDarkMode() ? Colors.black : backGroundColor ?? const Color(0xFFF6F7F9),
    borderRadius: BorderRadius.circular(8.r),
    border: Border.all(color: const Color(0xFFEDEEF1), width: 1.w),
  ),

  child: SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            getCircleBackground(IconDestination(isPickupPoint: isPickupPoint, color: ColorPalette.primary50)),
            Gap(4.w),
            Expanded(
              child: Text(
                title,
                style: context.bodyMedium?.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorPalette.primary50,
                ),
              ),
            ),
          ],
        ),
        Gap(8.h),
        Text(
          subTitle ?? '',
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: context.bodyMedium?.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: isDarkMode() ? Colors.grey.shade500 : const Color(0xFF687387),
          ),
        ),
      ],
    ),
  ),
);
