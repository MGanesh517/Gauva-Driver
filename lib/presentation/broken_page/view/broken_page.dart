import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/theme/color_palette.dart';
import 'package:gauva_driver/core/utils/exit_app_dialogue.dart';
import 'package:gauva_driver/core/utils/localize.dart';
import 'package:gauva_driver/core/widgets/buttons/app_primary_button.dart';
import 'package:gauva_driver/gen/assets.gen.dart';
import 'package:url_launcher/url_launcher.dart';

class BrokenPage extends StatelessWidget {
  const BrokenPage({super.key});

  @override
  Widget build(BuildContext context) => ExitAppWrapper(
    child: Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Assets.images.broken.image(height: 200.h, width: 200.w),
                Gap(24.h),
                Text(
                  localize(context).unexpected_application_crash,
                  textAlign: TextAlign.center,
                  style: context.bodyMedium?.copyWith(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF24262D),
                  ),
                ),
                Gap(8.h),
                Text(
                  localize(context).app_encountered_unexpected_error,
                  textAlign: TextAlign.center,
                  style: context.bodyMedium?.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF464D5E),
                  ),
                ),
                Gap(24.h),
                AppPrimaryButton(
                  backgroundColor: Colors.white,
                  onPressed: () async {
                    // await openWhatsApp(phoneNumber: '+8801336909483');
                  },
                  child: Text(
                    localize(context).contact_support,
                    style: context.bodyMedium?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: ColorPalette.primary50,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Future<void> openWhatsApp({required String phoneNumber}) async {
    final whatsappUrl = 'whatsapp://send?phone=$phoneNumber&text=';

    final uri = Uri.parse(whatsappUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // fallback - যদি অ্যাপ না থাকে, তাহলে browser এ wa.me খুলবে
      final fallback = Uri.parse('https://wa.me/$phoneNumber?text=');
      await launchUrl(fallback, mode: LaunchMode.externalApplication);
    }
  }
}
