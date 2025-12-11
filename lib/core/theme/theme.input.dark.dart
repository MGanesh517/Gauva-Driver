import 'package:flutter/material.dart';
import 'package:gauva_driver/core/theme/theme.input.dart';

InputDecorationTheme inputThemeDark(String fontPrimary, String fontSecondary) =>
    inputTheme(fontPrimary, fontSecondary).copyWith(
      filled: true,
      fillColor: Colors.black,
      hintStyle: inputTheme(fontPrimary, fontSecondary).hintStyle?.copyWith(color: Colors.white),
    );
