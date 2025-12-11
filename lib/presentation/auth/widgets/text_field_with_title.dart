import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/color_palette.dart';

OutlineInputBorder border([bool isFocused = false])=> OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: isFocused ? ColorPalette.primary50 : const Color(0xFFD7DAE0)));