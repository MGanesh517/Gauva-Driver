import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/utils/is_dark_mode.dart';

import '../../../core/enums/booking_status.dart';
import '../../../core/utils/localize.dart';
import '../../../gen/assets.gen.dart';
import '../provider/driver_providers.dart';
import '../provider/way_point_list_provider.dart';

Widget headingToDestination(BuildContext context) => Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    Text(
      localize(context).ride_started,
      style: context.bodyMedium?.copyWith(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: isDarkMode() ? const Color(0xFF687387) : const Color(0xFF24262D),
      ),
    ),
    Text(
      localize(context).follow_directions_comfortable,
      textAlign: TextAlign.center,
      style: context.bodyMedium?.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color(0xFF687387)),
    ),
    Gap(8.h),
    estimatedTimeWidget(context),

    Assets.images.carAnimation.image(height: 200.h, width: 358.w, fit: BoxFit.fill),

    Consumer(
      builder: (context, ref, _) {
        final onTripStatusNotifier = ref.read(ontripStatusNotifier.notifier);
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(EdgeInsets.zero),
                      minimumSize: WidgetStateProperty.all(Size.zero),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                    ),
                    onPressed: () {
                      onTripStatusNotifier.updateOnTripStatus(status: BookingStatus.reachedDestination);
                    },
                    child: const Text('Continue'),
                  ),
                ],
              ),
              Text(
                'Only for demo ',
                style: context.bodySmall?.copyWith(fontSize: 8.sp, fontWeight: FontWeight.w500, color: Colors.blueGrey),
              ),
            ],
          ),
        );
      },
    ),
  ],
);

Widget estimatedTimeWidget(BuildContext context) => Consumer(
  builder: (context, ref, _) {
    final state = ref.watch(routeNotifierProvider);

    final progress = ref.watch(routeProgressProvider);
    // Default value
    String timeText = '0 min';
    String distanceText = '0 km';

    // Update timeText based on state
    state.when(
      initial: () {
        timeText = '0 min';
        distanceText = '0 km';
      },
      loading: () {
        timeText = '0 min';
        distanceText = '0 km';
      },
      success: (data) {
        timeText = data.durationText;
        distanceText = data.distanceText;
      },
      error: (e) {
        timeText = '0 min';
        distanceText = '0 km';
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Time + Distance Info
        Row(
          children: [
            CircleAvatar(
              radius: 15.r,
              backgroundColor: const Color(0xFFF1F7FE),
              child: Icon(Icons.access_time, color: const Color(0xFF1469B5), size: 20.r),
            ),
            Gap(5.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localize(context).estimated_time,
                    style: context.bodyMedium?.copyWith(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF687387),
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: timeText,
                      style: context.bodyMedium?.copyWith(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        color: isDarkMode() ? const Color(0xFF687387) : const Color(0xFF24262D),
                      ),
                      children: [
                        TextSpan(
                          text: ' $distanceText',
                          style: context.bodyMedium?.copyWith(
                            fontSize: 10.sp,
                            color: const Color(0xFF1469B5),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Progress Bar with Car
        SizedBox(
          height: 50.h,
          child: Stack(
            children: [
              // Light background bar
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: isDarkMode() ? Colors.grey.shade500 : const Color(0xFFF1F7FE),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
              ),

              // Blue progress bar
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 10.h,
                  width: MediaQuery.of(context).size.width * 0.8 * progress,
                  margin: EdgeInsets.only(top: 1.h), // Optional fine-tune
                  decoration: BoxDecoration(color: const Color(0xFF1469B5), borderRadius: BorderRadius.circular(16.r)),
                ),
              ),

              // Car image
              Positioned(
                left: (progress * MediaQuery.of(context).size.width * 0.8 - 27.5.w).clamp(
                  0.0,
                  MediaQuery.of(context).size.width * 0.8 - 55.w,
                ),
                top: 3.h, // optional: center vertically
                child: Assets.images.carToViewLeftToRight.image(height: 43.h, width: 55.w, fit: BoxFit.contain),
              ),
            ],
          ),
        ),
      ],
    );
  },
);
