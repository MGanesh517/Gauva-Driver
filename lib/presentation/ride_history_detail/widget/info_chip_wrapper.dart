import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gauva_driver/core/utils/is_dark_mode.dart';

Widget infoChipWrapper({required Widget child}) => Expanded(
  child: Container(
    height: 30.h,
    alignment: Alignment.center,
    padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4.r),
      color: isDarkMode() ? Colors.black : Colors.white,
      border: isDarkMode() ? Border.all(color: Colors.white) : null,
    ),
    child: child,
  ),
);
