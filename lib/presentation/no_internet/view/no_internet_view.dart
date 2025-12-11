import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/theme/color_palette.dart';
import 'package:gauva_driver/core/utils/exit_app_dialogue.dart';
import 'package:gauva_driver/core/utils/is_dark_mode.dart';
import 'package:gauva_driver/core/utils/localize.dart';

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key});

  @override
  Widget build(BuildContext context) => ExitAppWrapper(
    child: Scaffold(
      backgroundColor: isDarkMode() ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text(
          localize(context).no_internet_connection,
          style: context.bodyLarge?.copyWith(
            color: isDarkMode() ? Colors.white : Colors.black,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 5,
        backgroundColor: isDarkMode() ? Colors.black : Colors.white,
      ),
      body: Center(
        child: SvgPicture.asset(
          'assets/svg/no-internet.svg',
          colorFilter: ColorFilter.mode(isDarkMode() ? ColorPalette.primary80 : ColorPalette.primary50, BlendMode.srcIn),
        ),
      ),
    ),
  );
}
