import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ionicons/ionicons.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/extensions/number_extension.dart';
import 'package:gauva_driver/core/routes/app_routes.dart';
import 'package:gauva_driver/core/utils/is_dark_mode.dart';
import 'package:gauva_driver/core/utils/localize.dart';
import 'package:gauva_driver/data/models/order_response/order_model/rider/rider.dart';
import 'package:gauva_driver/data/services/local_storage_service.dart';
import 'package:gauva_driver/data/services/navigation_service.dart';
import 'package:gauva_driver/presentation/booking/provider/driver_providers.dart';

import '../../../core/theme/color_palette.dart';
import '../../../data/services/url_launch_services.dart';

Widget riderDetails(BuildContext context, Rider? rider, {String? amount}) {
  final double height = 60;
  final double width = 60;
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: const Color(0xFFEDEEF1)),
    ),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: ColorPalette.primary50,
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: rider?.profilePicture ?? '',
                height: height.h,
                width: width.w,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: height.h,
                  width: width.w,
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                ),
                errorWidget: (context, url, error) => Container(
                  height: height.h,
                  width: width.w,
                  color: Colors.grey,
                  child: const Icon(Icons.error, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (rider?.name != null) ? (rider?.name ?? 'N/A') : (rider?.mobile ?? 'N/A'),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: context.bodyMedium?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode() ? const Color(0xFF687387) : const Color(0xFF24262D),
                ),
              ),
              Row(
                children: [
                  Icon(Icons.directions_car_outlined, size: 13.r, color: const Color(0xFF687387)),
                  Gap(4.w),
                  Text(
                    ((rider?.totalTrip ?? 0)).formattedCount,
                    style: context.bodyMedium?.copyWith(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF687387),
                    ),
                  ),
                  Gap(4.w),
                  Text(
                    localize(context).trips,
                    style: context.bodyMedium?.copyWith(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF687387),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        amount != null
            ? Column(
                children: [
                  Text(
                    localize(context).amount,
                    style: context.bodyMedium?.copyWith(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF687387),
                    ),
                  ),
                  Text(
                    '₹' + amount,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.bodyMedium?.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode() ? const Color(0xFF687387) : const Color(0xFF24262D),
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  Consumer(
                    builder: (context, ref, _) => getBackground(
                      icon: Ionicons.chatbubble_ellipses_outline,
                      backgroundColor: const Color(0xFFF6F7F9),
                      iconColor: isDarkMode() ? Colors.white : const Color(0xFF24262D),
                      onTap: () {
                        NavigationService.pushNamed(AppRoutes.chatSheet);
                        // tripNotifier.goToChat();
                      },
                    ),
                  ),
                  Gap(16.w),
                  getBackground(
                    icon: Ionicons.call_outline,
                    backgroundColor: const Color(0xFFF1F7FE),
                    iconColor: const Color(0xFF1469B5),
                    onTap: () {
                      UrlLaunchServices.launchDialer(rider?.mobile);
                    },
                  ),
                ],
              ),
      ],
    ),
  );
}

Widget getBackground({
  required IconData icon,
  required Color backgroundColor,
  required Color iconColor,
  void Function()? onTap,
}) => InkWell(
  onTap: onTap,
  child: Container(
    padding: EdgeInsets.all(10.r),
    decoration: BoxDecoration(
      color: isDarkMode() ? Colors.black12 : backgroundColor,
      borderRadius: BorderRadius.circular(4.r),
      border: isDarkMode() ? Border.all(color: Colors.white) : null,
    ),
    child: Icon(icon, color: iconColor, size: 19.r),
  ),
);
