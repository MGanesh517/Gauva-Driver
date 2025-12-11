import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gauva_driver/core/theme/color_palette.dart';
import 'package:gauva_driver/core/theme/outline_input_border.dart';
import 'package:gauva_driver/core/theme/theme.typography.dart';

InputDecorationTheme inputTheme(String fontPrimary, String fontSecondary) => InputDecorationTheme(
  filled: true,
  fillColor: Colors.white,
  iconColor: ColorPalette.neutral70,
  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  prefixIconColor: ColorPalette.neutral70,
  suffixIconColor: ColorPalette.neutral70,

  hintStyle: textTheme(fontPrimary, fontSecondary).bodyLarge,
  alignLabelWithHint: true,
  border: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
  focusedBorder: outlineInputBorder(isFocusBorder: true),
);
