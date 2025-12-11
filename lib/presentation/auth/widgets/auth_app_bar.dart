import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';

import '../../../core/theme/color_palette.dart';
import '../../../core/utils/is_dark_mode.dart';
import '../../../core/widgets/buttons/app_back_button.dart';
import '../../../gen/assets.gen.dart';
import '../../account_page/view/account_page.dart';

class AuthAppBar extends StatelessWidget {
  const AuthAppBar({super.key, this.showLeading = true, this.hideTop = false, this.title, this.child});
  final bool showLeading;
  final bool hideTop;
  final String? title;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 180.h,
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF397098), Color(0xFF942FAF)],
            ),
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
          ),
          child: hideTop
              ? const SizedBox.shrink()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(showLeading ? 50.h : 40.h),
                    showLeading
                        ? Row(
                            children: [
                              const AppBackButton(color: ColorPalette.neutral100),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: Text(
                                  title ?? '',
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: context.bodyMedium?.copyWith(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              countrySelector(showDecoration: true),
                            ],
                          )
                        : Row(
                            children: [
                              Assets.images.rideIn.image(height: 48.h, width: 79.w, fit: BoxFit.fill),
                              const Spacer(),
                              countrySelector(showDecoration: true),
                            ],
                          ),
                    Gap(showLeading ? 0 : 24.h),
                  ],
                ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: hideTop ? 45.h : 125.h, left: 16.w, right: 16.w, bottom: 16.h),
            child: Material(
              elevation: 6,
              borderRadius: BorderRadius.circular(16.r),
              color: isDarkMode() ? Colors.black : Colors.white,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                decoration: BoxDecoration(
                  color: isDarkMode() ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
