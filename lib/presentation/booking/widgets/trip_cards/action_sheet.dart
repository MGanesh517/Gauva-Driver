import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/utils/is_dark_mode.dart';
import 'package:gauva_driver/core/utils/localize.dart';

Widget actionSheet(
  BuildContext context, {
  Widget? riderInfo,
  Widget? locationTime,
  String title = '',
  String description = '',
  String? remainingTime,
  required Widget image,
  Widget? content,
  List<Widget> actions = const <Widget>[],
}) => Column(
  children: [
    riderInfo ?? const SizedBox.shrink(),
    Gap(locationTime != null ? 8.h : 0),
    locationTime ?? const SizedBox.shrink(),
    Gap(8.h),
    Text(
      title,
      textAlign: TextAlign.center,
      style: context.textTheme.bodyMedium?.copyWith(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: isDarkMode() ? const Color(0xFF687387) : const Color(0xFF24262D),
      ),
    ),
    Gap(4.h),
    Text(
      description,
      textAlign: TextAlign.center,
      style: context.textTheme.bodyMedium?.copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF687387),
      ),
    ),
    Gap(remainingTime == null ? 0 : 8.h),
    remainingTime == null
        ? const SizedBox.shrink()
        : Text(
            '${localize(context).you_can_cancel_ride_in} $remainingTime',
            textAlign: TextAlign.center,
            style: context.bodyMedium?.copyWith(fontSize: 15.sp, fontWeight: FontWeight.bold, color: Colors.red),
          ),
    Gap(8.h),
    image,
    Gap(content != null ? 8.h : 0),
    content ?? const SizedBox.shrink(),
    Gap(16.h),
    Row(children: actions),
    Gap(Platform.isIOS ? 4.h : 0),
  ],
);
