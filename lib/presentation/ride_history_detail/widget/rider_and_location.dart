import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/core/utils/is_dark_mode.dart';
import 'package:gauva_driver/data/models/order_response/order_model/order/order.dart';
import 'package:gauva_driver/presentation/ride_history_detail/widget/activity_map.dart';
import 'package:gauva_driver/presentation/ride_history_detail/widget/rider_info.dart';
import 'package:gauva_driver/presentation/ride_history_detail/widget/travel_info.dart';

Widget riderAndLocation(BuildContext context, WidgetRef ref, Order? order, {bool showCancelItem = false}) => Container(
  padding: EdgeInsets.all(8.r),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(8.r),
    color: isDarkMode() ? Colors.black : const Color(0xFFF6F7F9),
  ),
  child: Column(
    children: [
      riderInfo(context, order?.rider, order, showCancelItem: showCancelItem),
      Gap(8.h),
      travelInfo(context, order, showCancelItem: showCancelItem),
      Gap(8.h),
      activityMap(context, ref, order),
    ],
  ),
);
