import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gauva_driver/core/theme/color_scheme.light.dart';
import 'package:gauva_driver/core/theme/theme.input.dart';
import 'package:gauva_driver/core/theme/theme.typography.dart';

import 'color_palette.dart';
import 'color_scheme.dark.dart';
import 'theme.input.dark.dart';
import 'theme.typography.dark.dart';

class AppTheme {
  static ThemeData light(String fontPrimary, String fontSecondary) {
    final localTextTheme = textTheme(fontPrimary, fontSecondary);
    return ThemeData(
      colorScheme: lightColorScheme,
      cupertinoOverrideTheme: const CupertinoThemeData(primaryColor: ColorPalette.primary40),
      textTheme: localTextTheme,

      fontFamily: fontPrimary,
      scaffoldBackgroundColor: ColorPalette.neutralF6,
      appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
      inputDecorationTheme: inputTheme(fontPrimary, fontSecondary),
      dividerTheme: const DividerThemeData(color: ColorPalette.neutral95, thickness: 1.5),
      dividerColor: ColorPalette.neutral95,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(backgroundColor: Colors.white),
      bottomSheetTheme: BottomSheetThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      snackBarTheme: const SnackBarThemeData(backgroundColor: Colors.transparent, elevation: 0),
      dialogTheme: DialogThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return lightColorScheme.onSurface.withValues(alpha: 0.12);
            } else if (states.contains(WidgetState.hovered)) {
              return ColorPalette.primary50;
            } else if (states.contains(WidgetState.pressed)) {
              return ColorPalette.primary30;
            } else {
              return ColorPalette.primary40;
            }
          }),
          padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 24, vertical: 20)),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return lightColorScheme.onSurface.withValues(alpha: 0.12);
            } else {
              return lightColorScheme.onPrimary;
            }
          }),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ColorPalette.primary40;
          } else {
            return Colors.transparent;
          }
        }),
        side: const BorderSide(color: ColorPalette.primary40, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        selectedIcon: const SizedBox.shrink(),
        style: ButtonStyle(
          side: const WidgetStatePropertyAll(BorderSide(color: ColorPalette.primary95)),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          textStyle: WidgetStatePropertyAll(localTextTheme.bodyMedium),
          foregroundColor: WidgetStateColor.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return ColorPalette.primary30;
            } else {
              return ColorPalette.neutralVariant50;
            }
          }),
          backgroundColor: WidgetStateColor.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return ColorPalette.primary99;
            } else if (states.contains(WidgetState.hovered)) {
              return ColorPalette.primary99;
            } else {
              return Colors.transparent;
            }
          }),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: ColorPalette.neutralVariant99,
        foregroundColor: ColorPalette.neutral50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
        elevation: 2,
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: localTextTheme.bodyLarge,
        inputDecorationTheme: inputTheme(fontPrimary, fontSecondary),

        menuStyle: MenuStyle(
          backgroundColor: const WidgetStatePropertyAll(Color(0xffEEEDF1)),
          visualDensity: VisualDensity.compact,
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
        ),
      ),
      useMaterial3: true,
    );
  }

  static ThemeData dark(String fontPrimary, String fontSecondary) => light(fontPrimary, fontSecondary).copyWith(
    colorScheme: darkColorScheme,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
    inputDecorationTheme: inputThemeDark(fontPrimary, fontSecondary),
    textTheme: textThemeDark(fontPrimary, fontSecondary),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: ColorPalette.primary50,
      selectionColor: ColorPalette.primary50.withValues(alpha: 0.4),
      selectionHandleColor: ColorPalette.primary50,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.white, width: 0.5),
          ),
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.black,
      foregroundColor: ColorPalette.neutral50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
      elevation: 2,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(backgroundColor: ColorPalette.neutral10),
  );
}
