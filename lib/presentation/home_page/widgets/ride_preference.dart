import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/utils/localize.dart';

import '../../../core/utils/is_dark_mode.dart';
import '../../../data/models/order_response/order_model/ride_prefs/ride_preference.dart';

Widget ridePreference(BuildContext context, {List<RidePreference> preferenceList = const []}) {
  if (preferenceList.isEmpty) {
    return const SizedBox.shrink();
  }
  return SizedBox(
    height: 100.h,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localize(context).ride_preferences,
          style: context.bodyMedium?.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: isDarkMode() ? const Color(0xFF687387) : const Color(0xFF24262D),
          ),
        ),
        Gap(8.h),
        Expanded(
          child: ListView.builder(
            itemCount: preferenceList.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final RidePreference pref = preferenceList[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        pref.name?.capitalize() ?? '',
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF687387),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        (pref.additionalFee ?? 0).toStringAsFixed(2),
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: isDarkMode() ? const Color(0xFF687387) : const Color(0xFF24262D),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}
