import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';

Widget payInfo(BuildContext context, {String? value, String? title}) => Expanded(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title ?? '',
        style: context.bodyMedium?.copyWith(fontSize: 8.sp, fontWeight: FontWeight.w400, color: Colors.white54),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      Gap(4.h),
      Text(
        value ?? '',
        style: context.bodyMedium?.copyWith(fontSize: 10.sp, fontWeight: FontWeight.w600, color: Colors.white),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ],
  ),
);
