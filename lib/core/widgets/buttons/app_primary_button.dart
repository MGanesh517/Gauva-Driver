import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';

import '../../theme/color_palette.dart';
import '../../utils/is_dark_mode.dart';

class AppPrimaryButton extends StatelessWidget {
  final Function()? onPressed;
  final Widget child;
  final bool isDisabled;
  final PrimaryButtonColor color;
  final Color? backgroundColor;
  final bool isLoading;
  final double width;
  final bool showBorder;

  const AppPrimaryButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isDisabled = false,
    this.isLoading = false,
    this.color = PrimaryButtonColor.primary,
    this.backgroundColor,
    this.width = double.infinity,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = isDarkMode();

    return SafeArea(
      bottom: !Platform.isIOS,
      child: Container(
        width: width,
        height: 48,
        decoration: BoxDecoration(
          gradient: (isDisabled || isLoading)
              ? null
              : backgroundColor != null
              ? null
              : color == PrimaryButtonColor.primary
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF397098), Color(0xFF942FAF)],
                )
              : null,
          color: (isDisabled || isLoading)
              ? context.theme.colorScheme.onSurface.withValues(alpha: 0.12)
              : backgroundColor != null
              ? (isDark ? Colors.black : backgroundColor)
              : color == PrimaryButtonColor.error
              ? ColorPalette.error40
              : null,
          borderRadius: BorderRadius.circular(8),
          border: backgroundColor != null && showBorder ? Border.all(color: ColorPalette.primary50) : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: (isDisabled || isLoading) ? null : onPressed,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
              alignment: Alignment.center,
              child: isLoading
                  ? SizedBox(
                      height: 24,
                      width: 24,
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF397098), Color(0xFF942FAF)],
                        ).createShader(bounds),
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    )
                  : child,
            ),
          ),
        ),
      ),
    );
  }
}

enum PrimaryButtonColor { primary, error }
