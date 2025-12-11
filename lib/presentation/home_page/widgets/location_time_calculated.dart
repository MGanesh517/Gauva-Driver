import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ionicons/ionicons.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/utils/localize.dart';

import '../../../core/theme/color_palette.dart';
import '../../../core/utils/is_dark_mode.dart';
import '../../../gen/assets.gen.dart';
import '../../booking/provider/way_point_list_provider.dart';

Widget locationTime(BuildContext context, {String? time, String? distance}) => Consumer(
  builder: (context, ref, _) {
    final state = ref.watch(routeNotifierProvider);
    final String min = localize(context).min;
    final String km = localize(context).km;
    // Default value
    String timeText = '0 $min';
    String distanceText = '0 $km';

    // Update timeText based on state
    state.when(
      initial: () {
        timeText = '0 $min';
        distanceText = '0 $km';
      },
      loading: () {
        timeText = '0 $min';
        distanceText = '0 $km';
      },
      success: (data) {
        timeText = data.durationText;
        distanceText = data.distanceText;
      },
      error: (e) {
        timeText = '0 $min';
        distanceText = '0 $km';
      },
    );
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
        color: isDarkMode() ? Colors.black : const Color(0xFFF6F4FE),
      ),
      child: Row(
        children: [
          infoCard(context, title: distance ?? distanceText + (distance != null ? localize(context).km : '')),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: DottedLine(dashColor: ColorPalette.neutral90, lineThickness: 3, lineLength: 80),
          ),
          infoCard(context, showImage: false, title: time ?? timeText + (time != null ? localize(context).min : '')),
        ],
      ),
    );
  },
);

Widget infoCard(BuildContext context, {bool showImage = true, String? title}) => Expanded(
  child: Container(
    height: 40.h,
    width: double.infinity,
    padding: EdgeInsets.all(8.r),
    child: Row(
      children: [
        showImage
            ? Assets.images.route.image(height: 24.h, width: 24.w, fit: BoxFit.fill)
            : Icon(Ionicons.time_outline, color: ColorPalette.primary50, size: 24.r),
        Gap(8.w),
        Expanded(
          child: Text(
            title ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.bodyMedium?.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: isDarkMode() ? Colors.white : const Color(0xFF24262D),
            ),
          ),
        ),
      ],
    ),
  ),
);
