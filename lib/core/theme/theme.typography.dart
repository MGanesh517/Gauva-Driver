import 'package:flutter/material.dart';

TextTheme textTheme(String fontPrimary, String fontSecondary) {
  // Use local fonts for Inter (secondary font)
  const String fontFamily = 'Inter';

  final baseTextTheme = ThemeData.light().textTheme.apply(fontFamily: fontFamily);

  return baseTextTheme.copyWith(
    displayLarge: const TextStyle(
      fontFamily: fontFamily,
      fontSize: 57,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.25,
    ),
    displayMedium: const TextStyle(fontFamily: fontFamily, fontSize: 45, fontWeight: FontWeight.w700),
    displaySmall: const TextStyle(fontFamily: fontFamily, fontSize: 36, fontWeight: FontWeight.w700),
    headlineLarge: const TextStyle(fontFamily: fontFamily, fontSize: 32, fontWeight: FontWeight.w600),
    headlineMedium: const TextStyle(fontFamily: fontFamily, fontSize: 28, fontWeight: FontWeight.w600),
    headlineSmall: const TextStyle(fontFamily: fontFamily, fontSize: 24, fontWeight: FontWeight.w600),
    titleLarge: const TextStyle(fontFamily: fontFamily, fontSize: 22, fontWeight: FontWeight.w600),
    titleMedium: const TextStyle(fontFamily: fontFamily, fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: 0.15),
    titleSmall: const TextStyle(fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.10),
    labelLarge: const TextStyle(fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.10),
    labelMedium: const TextStyle(fontFamily: fontFamily, fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.50),
    labelSmall: const TextStyle(fontFamily: fontFamily, fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.50),
    bodyLarge: const TextStyle(fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.50),
    bodyMedium: const TextStyle(fontFamily: fontFamily, fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
    bodySmall: const TextStyle(fontFamily: fontFamily, fontSize: 12, fontWeight: FontWeight.w400),
  );
}
