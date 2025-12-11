import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/common/loading_view.dart';
import 'package:gauva_driver/core/utils/show_global_dialogue.dart';
import 'package:gauva_driver/data/services/local_storage_service.dart';
import 'package:gauva_driver/data/services/navigation_service.dart';
import 'package:gauva_driver/presentation/booking/view_model/reverse_timer_notifier.dart';
import 'package:gauva_driver/presentation/home_page/widgets/rider_details.dart';
import 'package:gauva_driver/presentation/home_page/widgets/location_time_calculated.dart';
import 'package:gauva_driver/presentation/home_page/widgets/order_request_buttons.dart';
import 'package:gauva_driver/presentation/home_page/widgets/readable_location_view.dart';
import 'package:gauva_driver/presentation/home_page/widgets/ride_preference.dart';

import '../../../core/utils/is_dark_mode.dart';
import '../../booking/provider/ride_providers.dart';

void orderRequestDialogue({bool showFromFirebase = false, num? orderId}) {
  if (Navigator.canPop(NavigationService.navigatorKey.currentContext!)) return;
  showGlobalAlertDialog(
    child: _OrderRequestDialog(showFromFirebase: showFromFirebase, orderId: orderId),
  );
}

class _OrderRequestDialog extends ConsumerStatefulWidget {
  final bool showFromFirebase;
  final num? orderId;
  const _OrderRequestDialog({this.showFromFirebase = false, this.orderId});

  @override
  ConsumerState<_OrderRequestDialog> createState() => _OrderRequestDialogState();
}

class _OrderRequestDialogState extends ConsumerState<_OrderRequestDialog> {
  @override
  void initState() {
    super.initState();
    showFromFirebase();
  }

  Future<void> showFromFirebase() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (widget.showFromFirebase) {
        ref.read(reverseTimerProvider.notifier).startTimer();
        final int? orderId = int.tryParse(widget.orderId.toString());
        if (orderId == null) return;
        await LocalStorageService().saveOrderId(orderId);
        ref.read(rideOrderNotifierProvider.notifier).orderDetails(orderId: orderId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(rideOrderNotifierProvider);
    // final remaining = ref.watch(reverseTimerProvider);
    // final notifier = ref.read(reverseTimerProvider.notifier);
    // final double progress =
    //     1 - (remaining / notifier.totalTime);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: isDarkMode() ? const BorderSide(color: Colors.white) : BorderSide.none,
      ),
      insetPadding: EdgeInsets.all(16.r),
      child: IntrinsicHeight(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: state.when(
            loading: () => const LoadingView(),
            success: (order) => Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // even spacing
              children: [
                riderDetails(context, order?.rider, amount: order?.payableAmount.toString()),
                Gap(8.h),
                locationTime(
                  context,
                  time: ((order?.duration ?? 0) / 60).toStringAsFixed(1),
                  distance: ((order?.distance ?? 0) / 1000).toStringAsFixed(1),
                ),
                Gap(8.h),
                readAbleLocationView(context, order?.addresses),
                Gap(8.h),
                ridePreference(context, preferenceList: order?.ridePreference ?? []),
                Gap(16.h),
                orderRequestButtons(context, orderId: order?.id),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
