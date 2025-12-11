import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/widgets/is_ios.dart';

import '../../../core/theme/color_palette.dart';
import '../../../core/utils/is_dark_mode.dart';
import '../../../core/widgets/buttons/app_primary_button.dart';

class AuthBottomButtons extends StatelessWidget {
  const AuthBottomButtons({
    super.key,
    this.showBothButtons = false,
    this.onSkip,
    required this.title,
    required this.onTap,
    this.isLoading = false,
  });
  final bool showBothButtons;
  final Function()? onSkip;
  final Function() onTap;
  final String title;
  final bool isLoading;

  @override
  Widget build(BuildContext context) => SafeArea(
    bottom: !isIos(),
    child: Container(
      // height: 96.h, //96
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      margin: EdgeInsets.only(bottom: isIos() ? 8.h : 0),
      // margin: EdgeInsets.all(16.r),
      decoration: BoxDecoration(color: isDarkMode() ? context.surface : Colors.white),
      child: AppPrimaryButton(
        isDisabled: isLoading,
        onPressed: onTap,
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: ColorPalette.neutral100,
          ),
        ),
      ),
    ),
  );
}
