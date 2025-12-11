import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'color_palette.dart';

OutlineInputBorder outlineInputBorder({bool isFocusBorder = false})=> OutlineInputBorder(
  borderRadius: BorderRadius.circular(8.r),
  borderSide: BorderSide(
      color: isFocusBorder ? ColorPalette.primary50 : const Color(0xFFD7DAE0),
      width: 1.w
  ),
);

BoxBorder boxBorder({bool isFocusBorder = false})=> BoxBorder.all(
  color: isFocusBorder ? ColorPalette.primary50 : const Color(0xFFD7DAE0),
  width: 1.w
);
