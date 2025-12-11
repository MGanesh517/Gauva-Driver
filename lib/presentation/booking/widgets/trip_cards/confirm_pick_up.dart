import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/core/enums/booking_status.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/utils/localize.dart';
import 'package:gauva_driver/core/widgets/buttons/app_primary_button.dart';
import 'package:gauva_driver/data/models/order_response/order_model/order/order.dart';
import 'package:gauva_driver/gen/assets.gen.dart';
import 'package:gauva_driver/presentation/booking/provider/cancel_ride_provider.dart';
import 'package:gauva_driver/presentation/booking/provider/driver_providers.dart';
import 'package:gauva_driver/presentation/booking/widgets/trip_cards/action_sheet.dart';
import 'package:gauva_driver/presentation/home_page/widgets/rider_details.dart';
import 'package:gauva_driver/presentation/home_page/widgets/location_time_calculated.dart';

import '../../provider/cancel_button_provider.dart';
import '../../provider/ride_providers.dart';
import '../../view_model/loading_notifier.dart';

Widget confirmPickup(BuildContext context, Order? order) => Consumer(
  builder: (context, ref, _) {
    final rideOrderNotifier = ref.read(rideOrderNotifierProvider.notifier);
    // final rideOrderState = ref.read(rideOrderNotifierProvider);
    final onTripNotifier = ref.read(ontripStatusNotifier.notifier);
    final timerState = ref.watch(cancelButtonEnableTimerProvider);
    final timerStateNotifier = ref.read(cancelButtonEnableTimerProvider.notifier);
    final cancelProvider = ref.read(cancelRideNotifierProvider.notifier);

    // final totalTime = 300.0; // 5 min = 300s
    // final double progress = 1 -
    //     (timerState.remainingSeconds / totalTime)
    //         .clamp(0.0, 1.0); // 0 → 1 progress

    return actionSheet(
      context,
      riderInfo: riderDetails(context, order?.rider),
      locationTime: locationTime(context),
      title: localize(context).pickup_rider,
      description: localize(context).double_check_rider,
      remainingTime: formatDuration(timerState.remainingSeconds) == '0s'
          ? null
          : formatDuration(timerState.remainingSeconds),
      image: Assets.images.confirmPickup.image(height: 130.h, width: 194.w, fit: BoxFit.fill),
      actions: [
        Expanded(
          child: AppPrimaryButton(
            isLoading: ref.watch(cancelRideNotifierProvider).whenOrNull(loading: () => true) ?? false,
            isDisabled: !timerState.isButtonEnabled,
            backgroundColor: timerState.isButtonEnabled ? Colors.red : null,
            showBorder: !timerState.isButtonEnabled, //!timerState.isButtonEnabled
            onPressed: () {
              cancelProvider.cancelRide();
            },
            child: Text(
              localize(context).cancel_ride,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.bodyMedium?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: timerState.isButtonEnabled ? Colors.white : Colors.red,
              ),
            ),
          ),
        ),
        Gap(16.w),
        Expanded(
          child: AppPrimaryButton(
            isLoading: ref.watch(loadingProvider),
            onPressed: () {
              rideOrderNotifier.saveOrderStatus(
                status: 'picked_up',
                onSuccess: (v) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    onTripNotifier.updateOnTripStatus(status: BookingStatus.rideStarted);
                    timerStateNotifier.cancelTimer();
                  });
                },
              );
            },
            child: Text(
              localize(context).confirm_pickup,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.bodyMedium?.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  },
);

class CancelButtonRedBorderPainter extends CustomPainter {
  final double progress; // 0.0 → no red, 1.0 → full red border

  CancelButtonRedBorderPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = 3;
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final RRect rRect = RRect.fromRectAndRadius(rect, const Radius.circular(8));

    // 🔘 Gray background border
    final Paint backgroundPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // 🔴 Red border for progress
    final Paint progressPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw background border
    canvas.drawRRect(rRect, backgroundPaint);

    // Draw red progress border (clockwise)
    final Path path = Path()..addRRect(rRect);
    final PathMetrics pathMetrics = path.computeMetrics();
    for (final PathMetric metric in pathMetrics) {
      final Path extractPath = metric.extractPath(0, metric.length * progress);
      canvas.drawPath(extractPath, progressPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CancelButtonRedBorderPainter oldDelegate) => oldDelegate.progress != progress;
}

String formatDuration(int totalSeconds) {
  final hours = totalSeconds ~/ 3600;
  final minutes = (totalSeconds % 3600) ~/ 60;
  final seconds = totalSeconds % 60;

  final parts = <String>[];

  if (hours > 0) parts.add('${hours}h');
  if (minutes > 0 || hours > 0) parts.add('${minutes}m');
  parts.add('${seconds}s');

  return parts.join(' ');
}
