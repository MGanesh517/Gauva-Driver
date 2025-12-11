import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/utils/localize.dart';

import '../../../core/utils/is_dark_mode.dart';

Widget detailsField(BuildContext context, TextEditingController controller) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      localize(context).details,
      textAlign: TextAlign.start,
      style: context.bodyMedium?.copyWith(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: isDarkMode() ? const Color(0xFF687387) : const Color(0xFF24262D),
      ),
    ),
    Gap(12.h),
    TextFormField(
      controller: controller,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: localize(context).writeIssueDetails,
        hintStyle: context.bodyMedium?.copyWith(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF687387),
        ),
      ),
    ),
  ],
);
