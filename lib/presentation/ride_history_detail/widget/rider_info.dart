import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/theme/color_palette.dart';
import 'package:gauva_driver/core/utils/format_date.dart';
import 'package:gauva_driver/core/utils/is_dark_mode.dart';
import 'package:gauva_driver/data/models/order_response/order_model/order/order.dart';
import 'package:gauva_driver/data/models/order_response/order_model/rider/rider.dart';
import 'package:gauva_driver/presentation/home_page/widgets/activity_card.dart';

Widget riderInfo(BuildContext context, Rider? rider, Order? order, {bool showCancelItem = false}) => Row(
  children: [
    showCancelItem
        ? buildImageError(40, 40)
        : CircleAvatar(
            radius: 25.r,
            backgroundColor: ColorPalette.primary50,
            child: CircleAvatar(
              radius: 24.r,
              backgroundImage: rider?.profilePicture != null ? CachedNetworkImageProvider(rider!.profilePicture!) : null,
            ),
          ),
    Gap(8.w),
    Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            rider?.name?.capitalize() ?? 'N/A',
            style: context.bodyMedium?.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: isDarkMode() ? Colors.white : const Color(0xFF24262D),
            ),
          ),
          Gap(4.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.star, color: Colors.amberAccent, size: 16.h),
              Gap(4.w),
              Text(
                (rider?.rating ?? 0).toString(),
                textAlign: TextAlign.start,
                style: context.bodyMedium?.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode() ? Colors.grey.shade400 : const Color(0xFF24262D),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          formatDateEnglish(order?.orderTime),
          style: context.bodyMedium?.copyWith(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: isDarkMode() ? Colors.grey.shade400 : const Color(0xFF24262D),
          ),
        ),
        Gap(4.h),
        Text(
          formatTimeEnglish(order?.orderTime),
          style: context.bodyMedium?.copyWith(
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF565F73),
          ),
        ),
      ],
    ),
  ],
);
