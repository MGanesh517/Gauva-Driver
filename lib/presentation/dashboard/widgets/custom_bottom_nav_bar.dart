import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gauva_driver/core/utils/localize.dart';
import 'package:gauva_driver/presentation/account_page/provider/theme_provider.dart';

import '../../../gen/assets.gen.dart';
import 'navigation_card.dart';

class CustomBottomNavBar extends ConsumerWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;
    final isIOS = Platform.isIOS;
    return SafeArea(
      bottom: isIOS ? false : true,
      child: Container(
        height: 80,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
        margin: isIOS ? EdgeInsets.only(bottom: 8.h) : EdgeInsets.zero,
        color: isDarkMode ? Colors.black54 : Colors.white,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: _buildNavItem(0, localize(context).home, Assets.icons.home, isDarkMode)),
                SizedBox(width: 4.w),
                Expanded(child: _buildNavItem(1, localize(context).intercityLabel, Assets.images.route, isDarkMode)),
                SizedBox(width: 4.w),
                Expanded(child: _buildNavItem(2, localize(context).ride_history, Assets.icons.rideHistory, isDarkMode)),
                SizedBox(width: 4.w),
                Expanded(child: _buildNavItem(3, localize(context).account, Assets.icons.account, isDarkMode)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String label, AssetGenImage iconAsset, bool isDark) {
    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(12),
      child: NavBarItem(
        icon: iconAsset.image(height: 24, width: 24, fit: BoxFit.fill),
        label: label,
        selected: index == currentIndex,
        isDark: isDark,
      ),
    );
  }
}
