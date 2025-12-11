import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/routes/app_routes.dart';
import 'package:gauva_driver/core/theme/color_palette.dart';
import 'package:gauva_driver/core/utils/localize.dart';
import 'package:gauva_driver/data/services/navigation_service.dart';

import '../../../core/utils/is_dark_mode.dart';

Widget addButton(BuildContext context) => InkWell(
  onTap: () {
    NavigationService.pushNamed(AppRoutes.addPaymentGateway);
  },
  child: Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
    decoration: BoxDecoration(
      color: isDarkMode() ? Colors.black : Colors.white,
      borderRadius: BorderRadius.circular(8.r),
      border: Border.all(color: ColorPalette.primary50),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          localize(context).add_new,
          style: context.bodyMedium?.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: ColorPalette.primary50,
          ),
        ),
        Gap(4.w),
        Icon(Icons.add, size: 18.h, color: ColorPalette.primary50),
      ],
    ),
  ),
);
