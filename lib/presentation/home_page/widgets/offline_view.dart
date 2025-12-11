import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gauva_driver/core/utils/is_dark_mode.dart';
import 'package:gauva_driver/presentation/home_page/widgets/summery.dart';
import 'package:gauva_driver/presentation/home_page/widgets/today_activity.dart';

Widget offlineView(BuildContext context) => Padding(
  padding: EdgeInsets.symmetric(horizontal: 16.w),
  child: Column(
    children: [
      summery(context),
      Container(
        height: 8.h,
        width: double.infinity,
        color: isDarkMode() ? Colors.grey.shade600 : const Color(0xFFF6F7F9),
      ),
      Expanded(child: todayActivity(context)),
    ],
  ),
);
