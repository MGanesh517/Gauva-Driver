import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/utils/is_dark_mode.dart';
import 'package:gauva_driver/gen/assets.gen.dart';
import 'package:gauva_driver/presentation/booking/provider/home_providers.dart';

import '../../../core/utils/localize.dart';

Widget currentLocationView(BuildContext context, {String? location}) => Row(
  children: [
    Expanded(
      child: Text(
        localize(context).location,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.bodyMedium?.copyWith(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: isDarkMode() ? Colors.white : const Color(0xFF24262D),
        ),
      ),
    ),
    Gap(16.w),
    Assets.images.locationPin.image(height: 18.h, width: 18.w, fit: BoxFit.fill),
    Gap(4.w),
    Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(bookingNotifierProvider);
        return Expanded(
          flex: 2,
          child: Text(
            state.address ?? '-',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.bodyMedium?.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF687387),
            ),
          ),
        );
      },
    ),
  ],
);
