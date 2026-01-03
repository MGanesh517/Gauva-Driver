import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ionicons/ionicons.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/utils/is_dark_mode.dart';
import 'package:gauva_driver/core/utils/localize.dart';
import 'package:gauva_driver/data/models/order_response/order_model/rider/rider.dart';

import '../../../core/theme/color_palette.dart';
import '../../../data/services/url_launch_services.dart';

Widget riderDetails(BuildContext context, Rider? rider, {String? amount}) => Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: const Color(0xFFEDEEF1)),
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: ColorPalette.primary50,
          backgroundImage: (rider?.profilePicture?.isNotEmpty ?? false)
              ? CachedNetworkImageProvider(rider!.profilePicture!)
              : null,
          child: (rider?.profilePicture?.isEmpty ?? true)
              ? Text(
                  (rider?.name?.isNotEmpty ?? false) ? rider!.name![0].toUpperCase() : 'R',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                )
              : null,
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
              // Row(
              //   children: [
              //     Icon(Icons.directions_car_outlined, size: 13.r, color: const Color(0xFF687387)),
              //     Gap(4.w),
              //     Text(
              //       ((rider?.totalTrip ?? 0)).formattedCount,
              //       style: context.bodyMedium?.copyWith(
              //         fontSize: 10.sp,
              //         fontWeight: FontWeight.w500,
              //         color: const Color(0xFF687387),
              //       ),
              //     ),
              //     Gap(4.w),
              //     Text(
              //       localize(context).trips,
              //       style: context.bodyMedium?.copyWith(
              //         fontSize: 10.sp,
              //         fontWeight: FontWeight.w600,
              //         color: const Color(0xFF687387),
              //       ),
              //     ),
              //   ],
              // ),
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
                  Gap(8.w),
                  // Consumer(
                  //   builder: (context, ref, _) => getBackground(
                  //     icon: Ionicons.chatbubble_ellipses_outline,
                  //     backgroundColor: const Color(0xFFF6F7F9),
                  //     iconColor: isDarkMode() ? Colors.white : const Color(0xFF24262D),
                  //     onTap: () {
                  //       NavigationService.pushNamed(AppRoutes.chatSheet);
                  //       // tripNotifier.goToChat();
                  //     },
                  //   ),
                  // ),
                  // Gap(16.w),
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

Widget getBackground({
  required IconData icon,
  required Color backgroundColor,
  required Color iconColor,
  void Function()? onTap,
}) => InkWell(
  onTap: onTap,
  child: Container(
    padding: EdgeInsets.all(12.r),
    decoration: BoxDecoration(
      color: isDarkMode() ? Colors.black12 : backgroundColor,
      borderRadius: BorderRadius.circular(4.r),
      border: isDarkMode() ? Border.all(color: Colors.white) : null,
    ),
    child: Icon(icon, color: iconColor, size: 19.r),
  ),
);
