import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/utils/is_dark_mode.dart';

import '../../../core/utils/localize.dart';

Widget topContent(BuildContext context) => Column(
  children: [
    Text(
      localize(context).reportIssueTitle,
      textAlign: TextAlign.center,
      style: context.bodyMedium?.copyWith(
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
        color: isDarkMode() ? const Color(0xFF687387) : const Color(0xFF24262D),
      ),
    ),
    Gap(8.h),
    Text(
      localize(context).reportIssueSubtitle,
      textAlign: TextAlign.center,
      style: context.bodyMedium?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, color: const Color(0xFF687387)),
    ),
  ],
);
